import 'package:banpay/api/repository/pokemons/pokemons_remote_service.dart';
import 'package:banpay/common/result.dart';
import '../mixin/result_to_response.dart';
import 'model/pokemons_response.dart';

class PokemonsRepository with ResultToResponse {
  const PokemonsRepository(this._remoteService);

  final PokemonsRemoteService _remoteService;

  Future<Result<PokemonsResponse>> getPokemons(
      {int limit = 30, int offset = 0}) async {
    return handleResult(() async {
      final response =
          await _remoteService.getPokemons(limit: limit, offset: offset);
      return Result.success(response);
    });
  }
}
