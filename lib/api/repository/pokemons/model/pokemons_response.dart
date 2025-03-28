import 'package:freezed_annotation/freezed_annotation.dart';
import 'pokemons.dart';

part 'pokemons_response.freezed.dart';
part 'pokemons_response.g.dart';

@freezed
class PokemonsResponse with _$PokemonsResponse {
  const factory PokemonsResponse({
    required int count,
    String? next,
    String? previous,
    required List<Pokemons> results,
  }) = _PokemonsResponse;

  factory PokemonsResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonsResponseFromJson(json);
}
