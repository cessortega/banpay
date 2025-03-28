import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'model/pokemon_detail_response.dart';

final _logger = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class PokemonDetailRemoteService {
  final Dio _dio;

  PokemonDetailRemoteService(this._dio);

  Future<PokemonDetailResponse> getDetail(String name) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/pokemon/$name',
        options: Options(responseType: ResponseType.json),
      );

      return PokemonDetailResponse.fromJson(response.data!);
    } on DioException catch (e) {
      _logger.e('Dio error: ${e.message}');
      if (e.response?.data != null) {
        _logger.w('Response data: ${e.response?.data}');
      }
      rethrow;
    }
  }
}
