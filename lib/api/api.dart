import 'package:banpay/api/repository/pokemon_detail/pokemon_detail_remote_service.dart';
import 'package:banpay/api/repository/pokemon_detail/pokemon_detail_repository.dart';
import 'package:banpay/api/repository/pokemons/pokemons_remote_service.dart';
import 'package:banpay/api/repository/pokemons/pokemons_repository.dart';

import 'package:dio/dio.dart';

class Api {
  const Api._();

  static Dio? _dioInstance;

  static PokemonsRemoteService? _pokemonsService;
  static PokemonDetailRemoteService? _pokemonDetailService;

  static void setup({required String baseUrl}) {
    _dioInstance = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ))
      ..interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));

    _pokemonsService = PokemonsRemoteService(_dioInstance!);
    _pokemonDetailService = PokemonDetailRemoteService(_dioInstance!);
  }

  static PokemonsRepository pokemonsRepository() {
    if (_dioInstance == null) {
      throw Exception('Api not initialized. Call setup() first');
    }
    return PokemonsRepository(
      _pokemonsService ?? PokemonsRemoteService(_dioInstance!),
    );
  }

  static PokemonDetailRepository pokemonDetailRepository() {
    if (_dioInstance == null) {
      throw Exception('Api not initialized. Call setup() first');
    }
    return PokemonDetailRepository(
      _pokemonDetailService ?? PokemonDetailRemoteService(_dioInstance!),
    );
  }
}
