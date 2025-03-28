import 'package:banpay/api/repository/pokemon_favorite/model/pokemon_favorite_hive.dart';
import 'package:banpay/api/repository/pokemon_favorite/pokemon_favorite_storage.dart';
import 'package:banpay/common/result.dart';
import 'package:banpay/database/database.dart';

class PokemonFavoriteUseCase {
  final PokemonFavoriteStorage _storage;

  PokemonFavoriteUseCase()
      : _storage = Database.storage<PokemonFavoriteStorage>();

  PokemonFavoriteUseCase.withStorage(this._storage);

  Future<EmptyResult> addFavorite(PokemonFavoriteHive pokemon) {
    return _storage.save(pokemon);
  }

  Future<Result<List<PokemonFavoriteHive>>> getFavorites() {
    return _storage.getAll();
  }

  Future<EmptyResult> removeFavorite(String id) {
    return _storage.deleteById(id);
  }

  Future<bool> isFavorite(String id) {
    return _storage.isFavorite(id);
  }

  Future<EmptyResult> clearFavorites() {
    return _storage.delete();
  }
}
