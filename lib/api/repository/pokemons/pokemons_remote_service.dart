import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'model/pokemons_response.dart';

final _logger = Logger();

class PokemonsRemoteService {
  final Dio _dio;

  PokemonsRemoteService(this._dio);

  Future<PokemonsResponse> getPokemons({int limit = 30, int offset = 0}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/pokemon',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
        options: Options(responseType: ResponseType.json),
      );

      return PokemonsResponse.fromJson(response.data!);
    } on DioException catch (e) {
      _logger.e('Dio error in PokemonsRemoteService - ${e.message}');
      _logger.e('Response data: ${e.response?.data}');
      rethrow;
    }
  }
}
