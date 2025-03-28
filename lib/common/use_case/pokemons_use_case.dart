import 'package:banpay/api/repository/pokemons/model/pokemons_response.dart';
import 'package:banpay/api/repository/pokemons/pokemons_repository.dart';

import '../result.dart';

class PokemonsUseCase {
  final PokemonsRepository _repository;

  PokemonsUseCase(this._repository);

  Future<Result<PokemonsResponse>> call(
      {int limit = 30, int offset = 0}) async {
    try {
      final pokemonsResult =
          await _repository.getPokemons(limit: limit, offset: offset);
      return pokemonsResult;
    } catch (e) {
      return Result.failure('Error fetching pokemons in PokemonsUseCase: $e');
    }
  }
}
