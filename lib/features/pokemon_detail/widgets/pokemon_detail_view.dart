import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../provider/pokemon_detail_provider.dart';

import '../../../api/repository/pokemon_detail/model/pokemon_detail_response.dart';
import '../../../api/repository/pokemons/model/pokemons.dart';
import '../../../widgets/favorite_widget/view/favorite_widget_page.dart';

class PokemonDetailView extends ConsumerStatefulWidget {
  final Pokemons pokemon;

  const PokemonDetailView({super.key, required this.pokemon});

  @override
  ConsumerState<PokemonDetailView> createState() => _PokemonDetailViewState();
}

class _PokemonDetailViewState extends ConsumerState<PokemonDetailView> {
  final _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer.periodic(const Duration(seconds: 3), (_) {
        if (!_pageController.hasClients) return;

        _currentPage = (_currentPage + 1) % 2;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(pokemonDetailProvider(widget.pokemon.name));

    return Column(
      children: [
        Hero(
          tag: 'pokemon-image-${widget.pokemon.name}',
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: widget.pokemon.image,
                height: 250,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
              Positioned(
                bottom: 8,
                right: 16,
                child: FavoriteWidgetPage(pokemon: widget.pokemon),
              ),
            ],
          ),
        ),
        detail.when(
          loading: () => const Expanded(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Expanded(
            child: Center(child: Text('Error: $error')),
          ),
          data: (pokemonDetail) => Expanded(
            child: Column(
              children: [
                PokemonInfoSummary(
                  weight: pokemonDetail.weight,
                  height: pokemonDetail.height,
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: [
                      PokemonAbilitiesView(abilities: pokemonDetail.abilities),
                      PokemonStatsView(stats: pokemonDetail.stats),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PokemonAbilitiesView extends StatelessWidget {
  final List<PokemonAbility> abilities;

  const PokemonAbilitiesView({super.key, required this.abilities});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: abilities.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final ability = abilities[index];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: ability.isHidden
                ? Colors.purple.shade100
                : Colors.blue.shade100,
            border: Border.all(
              color: ability.isHidden
                  ? Colors.purple.shade400
                  : Colors.blue.shade400,
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ability.ability.name,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (ability.isHidden)
                const Text(
                  'Oculta',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.black54),
                ),
            ],
          ),
        );
      },
    );
  }
}

class PokemonStatsView extends StatelessWidget {
  final List<PokemonStat> stats;

  const PokemonStatsView({super.key, required this.stats});

  static final statColors = [
    Color(0xFF095EEA),
    Color(0xFF6A2CD8),
    Color(0xFFBFD43C),
    Color(0xFF8E1412),
    Color(0xFFCE2F48),
    Color(0xFF1A0E35),
    Color(0xFFF594D7),
    Color(0xFF5632BD),
    Color(0xFFACD1A8),
    Color(0xFF9715E0),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: stats.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final stat = stats[index];
        final color = statColors[index % statColors.length];

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 1.2),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  stat.stat.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                stat.baseStat.toString(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.black87),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PokemonInfoSummary extends StatelessWidget {
  final int weight;
  final int height;

  const PokemonInfoSummary(
      {super.key, required this.weight, required this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _InfoTile(label: 'Peso', value: '${weight / 10} kg'),
          _InfoTile(label: 'Altura', value: '${height / 10} m'),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
