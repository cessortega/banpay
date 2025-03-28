import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/pokemon_list_provider.dart';
import '../widgets/pagination_controls.dart';
import '../widgets/pokemon_grid.dart';

class PokemonListPage extends ConsumerStatefulWidget {
  const PokemonListPage({super.key});

  @override
  ConsumerState<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends ConsumerState<PokemonListPage> {
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;
  bool _hasReturnedFromDetail = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();

    _searchController.addListener(() {
      ref.read(pokemonSearchProvider.notifier).state = _searchController.text;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hasReturnedFromDetail = true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_hasReturnedFromDetail) {
      FocusScope.of(context).unfocus();
      _hasReturnedFromDetail = false;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handlePagination(String url) {
    FocusScope.of(context).unfocus();
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    ref.read(pokemonListProvider.notifier).fetchFromUrl(url);
    ref.read(pokemonSearchProvider.notifier).state = '';
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pokemonListProvider);
    final searchQuery = ref.watch(pokemonSearchProvider).toLowerCase();

    return Scaffold(
      appBar: AppBar(title: const Text('Pokémons'), centerTitle: true),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: true,
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              flexibleSpace: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar Pokémon...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      isDense: true,
                      filled: true,
                    ),
                  ),
                ),
              ),
              expandedHeight: 72,
            ),
          ];
        },
        body: Column(
          children: [
            Expanded(
              child: state.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Error: $error')),
                data: (pokemons) {
                  final filtered = pokemons.results
                      .where((p) => p.name.toLowerCase().contains(searchQuery))
                      .toList();

                  final child = filtered.isEmpty
                      ? const Center(
                          child: Text('No se encontraron resultados'))
                      : PokemonGrid(
                          key: ValueKey(filtered.map((e) => e.name).join(',')),
                          pokemons: filtered,
                        );

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: child,
                  );
                },
              ),
            ),
            if (state is AsyncData)
              PaginationControls(
                previous: state.value?.previous,
                next: state.value?.next,
                onPrevious: _handlePagination,
                onNext: _handlePagination,
              ),
          ],
        ),
      ),
    );
  }
}
