import 'package:flutter/material.dart';

import '../../../api/repository/pokemons/model/pokemons.dart';
import '../widgets/pokemon_detail_view.dart';

class PokemonDetailPage extends StatelessWidget {
  final Pokemons pokemon;

  const PokemonDetailPage({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: PokemonDetailView(pokemon: pokemon),
    );
  }
}
