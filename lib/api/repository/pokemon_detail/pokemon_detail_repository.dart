import 'package:banpay/common/result.dart';
import 'model/pokemon_detail_response.dart';
import 'pokemon_detail_remote_service.dart';

import '../mixin/result_to_response.dart';

class PokemonDetailRepository with ResultToResponse {
  const PokemonDetailRepository(this._remoteService);

  final PokemonDetailRemoteService _remoteService;

  Future<Result<PokemonDetailResponse>> getDetail(String name) async {
    return handleResult(() async {
      final response = await _remoteService.getDetail(name);
      return Result.success(response);
    });
  }
}
