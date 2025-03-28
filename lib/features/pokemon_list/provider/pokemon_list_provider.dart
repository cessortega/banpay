import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/api.dart';
import '../../../api/repository/pokemons/model/pokemons.dart';
import '../../../api/repository/pokemons/model/pokemons_response.dart';
import '../../../common/di/commons_module.dart';
import '../../../common/route/router.dart';
import '../../../common/use_case/pokemons_use_case.dart';

final pokemonListProvider = StateNotifierProvider.autoDispose<
    PokemonListNotifier, AsyncValue<PokemonsResponse>>((ref) {
  final useCase = ref.watch(pokemonsUseCaseProvider);
  final router = CommonsModule.router();

  return PokemonListNotifier(useCase, router);
});

final pokemonsUseCaseProvider = Provider<PokemonsUseCase>((ref) {
  final repository = Api.pokemonsRepository();
  return PokemonsUseCase(repository);
});

class PokemonListNotifier extends StateNotifier<AsyncValue<PokemonsResponse>> {
  final PokemonsUseCase _useCase;
  final Router _router;

  PokemonListNotifier(this._useCase, this._router)
      : super(const AsyncValue.loading()) {
    fetchPokemons();
  }

  Future<void> fetchPokemons({int limit = 30, int offset = 0}) async {
    state = const AsyncValue.loading();
    final result = await _useCase(limit: limit, offset: offset);

    result.thenDo(
      (success) => state = AsyncValue.data(success.data),
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
    );
  }

  Future<void> fetchFromUrl(String url) async {
    state = const AsyncValue.loading();

    final uri = Uri.parse(url);
    final offset = int.tryParse(uri.queryParameters['offset'] ?? '0') ?? 0;
    final limit = int.tryParse(uri.queryParameters['limit'] ?? '30') ?? 30;

    final result = await _useCase(limit: limit, offset: offset);

    result.thenDo(
      (success) => state = AsyncValue.data(success.data),
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
    );
  }

  void onPokemonDetailClick(Pokemons pokemon) {
    _router.pushTo(PokemonDetailRoute(pokemon));
  }
}

final pokemonSearchProvider = StateProvider.autoDispose<String>((ref) => '');

final filteredPokemonProvider = Provider.autoDispose<List<Pokemons>>((ref) {
  final state = ref.watch(pokemonListProvider);
  final query = ref.watch(pokemonSearchProvider).toLowerCase();

  return state.maybeWhen(
    data: (data) => data.results
        .where((pokemon) => pokemon.name.toLowerCase().contains(query))
        .toList(),
    orElse: () => [],
  );
});


