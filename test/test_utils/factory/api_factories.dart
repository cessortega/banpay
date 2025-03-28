import 'package:banpay/api/repository/pokemon_detail/model/pokemon_detail_response.dart';
import 'package:banpay/api/repository/pokemons/model/pokemons.dart';
import 'package:banpay/api/repository/pokemons/model/pokemons_response.dart';

PokemonsResponse buildPokemonsResponse({
  List<Pokemons>? results,
}) {
  return PokemonsResponse(
    count: results?.length ?? 3,
    next: null,
    previous: null,
    results: results ??
        const [
          Pokemons(
              name: 'Bulbasaur', url: 'https://pokeapi.co/api/v2/pokemon/1/'),
          Pokemons(
              name: 'Ivysaur', url: 'https://pokeapi.co/api/v2/pokemon/2/'),
          Pokemons(
              name: 'Venusaur', url: 'https://pokeapi.co/api/v2/pokemon/3/'),
        ],
  );
}

String buildPaginationUrl({required int offset, required int limit}) {
  return 'https://pokeapi.co/api/v2/pokemon?offset=$offset&limit=$limit';
}

Pokemons buildPokemon({
  String name = 'pikachu',
  String url = 'https://pokeapi.co/api/v2/pokemon/25/',
}) {
  return Pokemons(
    name: name,
    url: url,
  );
}

PokemonDetailResponse buildPokemonDetail({
  int id = 25,
  String name = 'pikachu',
  int height = 4,
  int weight = 60,
  List<PokemonTypeSlot>? types,
  List<PokemonAbility>? abilities,
  List<PokemonStat>? stats,
}) {
  return PokemonDetailResponse(
    id: id,
    name: name,
    height: height,
    weight: weight,
    types: types ??
        [
          const PokemonTypeSlot(
            slot: 1,
            type: NamedApiResource(
              name: 'electric',
              url: 'https://pokeapi.co/api/v2/type/13/',
            ),
          ),
        ],
    abilities: abilities ??
        [
          const PokemonAbility(
            ability: NamedApiResource(
              name: 'static',
              url: 'https://pokeapi.co/api/v2/ability/9/',
            ),
            isHidden: false,
          ),
        ],
    stats: stats ??
        [
          const PokemonStat(
            baseStat: 90,
            stat: NamedApiResource(
              name: 'speed',
              url: 'https://pokeapi.co/api/v2/stat/6/',
            ),
          ),
          const PokemonStat(
            baseStat: 55,
            stat: NamedApiResource(
              name: 'attack',
              url: 'https://pokeapi.co/api/v2/stat/2/',
            ),
          ),
          const PokemonStat(
            baseStat: 40,
            stat: NamedApiResource(
              name: 'defense',
              url: 'https://pokeapi.co/api/v2/stat/3/',
            ),
          ),
        ],
  );
}
