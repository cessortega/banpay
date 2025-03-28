import 'flutter_module.dart';
import 'package:banpay/common/route/router.dart';

import '../../api/repository/pokemon_favorite/pokemon_favorite_storage.dart';

abstract class CommonsModule {
  static Router router() => Router(FlutterModule.navigatorKey());

  static PokemonFavoriteStorage pokemonFavoriteStorage() =>
      _pokemonFavoriteStorage ??= PokemonFavoriteStorage();

  static PokemonFavoriteStorage? _pokemonFavoriteStorage;
}
