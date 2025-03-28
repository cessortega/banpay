import 'package:hive/hive.dart';

part 'pokemon_favorite_hive.g.dart';

@HiveType(typeId: 0, adapterName: 'PokemonFavoriteHiveAdapter')
class PokemonFavoriteHive extends HiveObject {
  PokemonFavoriteHive({
    required this.name,
    required this.url,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  String url;

  String get id => url.split('/').where((e) => e.isNotEmpty).last;

  String get image =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}