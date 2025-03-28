import 'package:banpay/features/pokemon_list/view/pokemon_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api/api.dart';
import 'api/repository/pokemon_favorite/pokemon_favorite_storage.dart';
import 'common/di/commons_module.dart';
import 'common/di/flutter_module.dart';
import 'database/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeServices();

  runApp(ProviderScope(child: MyApp()));
}

Future<void> _initializeServices() async {

  /// Initialize the database with the storage classes.
  /// This is required to store the favorite pokemons.
  await Database.initialize([
    PokemonFavoriteStorage(),
  ]);

  /// Initialize the API with the base URL of the PokeAPI service. ( https://pokeapi.co/api/v2/ )
  /// This is required to make the API calls.
  /// It can be in mode development or production.
  Api.setup(baseUrl: 'https://pokeapi.co/api/v2/');
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final router = CommonsModule.router();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'banpay',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: FlutterModule.navigatorKey(),
      initialRoute: 'POKEMON_LIST',
      onGenerateRoute: router.generateRoute,
      home: const PokemonListPage(),
    );
  }
}
