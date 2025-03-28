import 'package:banpay/features/pokemon_detail/view/pokemon_detail_page.dart';
import 'package:banpay/features/pokemon_list/view/pokemon_list_page.dart';
import 'package:flutter/widgets.dart';
import 'router.dart';

import '../../api/repository/pokemons/model/pokemons.dart';


class PokemonListRoute extends PathRoute {
  const PokemonListRoute();

  @override
  String get name => 'POKEMON_LIST';

  @override
  Map<String, dynamic> get arguments => {};

  @override
  Widget get page => const PokemonListPage();
}

class PokemonDetailRoute extends PathRoute {
  const PokemonDetailRoute(this.pokemon);

  final Pokemons pokemon;

  @override
  String get name => 'POKEMON_DETAIL';

  @override
  Map<String, dynamic> get arguments => {'pokemon': pokemon};

  @override
  Widget get page => PokemonDetailPage(pokemon: pokemon);
}