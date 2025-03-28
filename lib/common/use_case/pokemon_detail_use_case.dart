import 'package:banpay/common/result.dart';

import '../../api/repository/pokemon_detail/model/pokemon_detail_response.dart';
import '../../api/repository/pokemon_detail/pokemon_detail_repository.dart';

class PokemonDetailUseCase {
  final PokemonDetailRepository _repository;

  PokemonDetailUseCase(this._repository);

  Future<Result<PokemonDetailResponse>> call(String name) async {
    try {
      final result = await _repository.getDetail(name);
      return result;
    } catch (e) {
      return Result.failure('Error fetching detail for $name: $e');
    }
  }
}
