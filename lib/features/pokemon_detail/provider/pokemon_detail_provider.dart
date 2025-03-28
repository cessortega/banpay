import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:banpay/api/api.dart';

import '../../../api/repository/pokemon_detail/model/pokemon_detail_response.dart';
import '../../../common/use_case/pokemon_detail_use_case.dart';

final pokemonDetailProvider = StateNotifierProvider.autoDispose
    .family<PokemonDetailNotifier, AsyncValue<PokemonDetailResponse>, String>(
  (ref, name) {
    final useCase = ref.watch(pokemonDetailUseCaseProvider);
    return PokemonDetailNotifier(useCase, name);
  },
);

final pokemonDetailUseCaseProvider = Provider<PokemonDetailUseCase>(
  (ref) => PokemonDetailUseCase(Api.pokemonDetailRepository()),
);

class PokemonDetailNotifier
    extends StateNotifier<AsyncValue<PokemonDetailResponse>> {
  final String name;
  final PokemonDetailUseCase _useCase;

  PokemonDetailNotifier(this._useCase, this.name)
      : super(const AsyncValue.loading()) {
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    state = const AsyncValue.loading();
    final result = await _useCase(name);

    result.thenDo(
      (success) => state = AsyncValue.data(success.data),
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
    );
  }
}
