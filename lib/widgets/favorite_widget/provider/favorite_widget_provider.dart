import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:banpay/api/repository/pokemons/model/pokemons.dart';
import 'package:banpay/api/repository/pokemon_favorite/model/pokemon_favorite_hive.dart';
import 'package:banpay/common/use_case/pokemon_favorite_use_case.dart';

final favoriteWidgetProvider = StateNotifierProvider.autoDispose
    .family<FavoriteWidgetController, bool?, Pokemons>((ref, pokemon) {
  final useCase = ref.watch(pokemonFavoriteUseCaseProvider);
  return FavoriteWidgetController(useCase: useCase, pokemon: pokemon);
});

class FavoriteWidgetController extends StateNotifier<bool?> {
  final PokemonFavoriteUseCase useCase;
  final Pokemons pokemon;

  FavoriteWidgetController({
    required this.useCase,
    required this.pokemon,
  }) : super(null) {
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final isFavorite = await useCase.isFavorite(pokemon.id);
    state = isFavorite;
  }

  Future<void> toggleFavorite() async {
    final current = state ?? false;
    if (current) {
      await useCase.removeFavorite(pokemon.id);
    } else {
      final favorite = PokemonFavoriteHive(
        name: pokemon.name,
        url: pokemon.url,
      );
      await useCase.addFavorite(favorite);
    }

    state = !current;
  }
}

final pokemonFavoriteUseCaseProvider = Provider<PokemonFavoriteUseCase>((ref) {
  return PokemonFavoriteUseCase();
});
