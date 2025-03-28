import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemons.freezed.dart';
part 'pokemons.g.dart';

@freezed
class Pokemons with _$Pokemons {
  const factory Pokemons({
    required String name,
    required String url,
  }) = _Pokemons;

  factory Pokemons.fromJson(Map<String, dynamic> json) =>
      _$PokemonsFromJson(json);
}

extension PokemonsX on Pokemons {
  String get id => url.split('/').where((e) => e.isNotEmpty).last;

  String get image =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}
