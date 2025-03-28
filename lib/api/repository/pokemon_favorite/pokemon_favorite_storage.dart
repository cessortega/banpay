import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:banpay/common/result.dart';
import 'package:banpay/database/storage.dart';
import 'model/pokemon_favorite_hive.dart';

class PokemonFavoriteStorage extends Storage {
  PokemonFavoriteStorage();

  Box<PokemonFavoriteHive>? _box;

  @override
  String get name => 'POKEMON_FAVORITES_STORAGE';

  @override
  Future<void> initialize() async {
    try {
      _box = await Hive.openBox<PokemonFavoriteHive>('pokemon_favorites');
    } catch (e) {
      Logger().e('Error initializing $name: $e');
    }
  }

  Future<EmptyResult> save(PokemonFavoriteHive pokemon) async {
    final box = _box;
    if (box == null) {
      return Result.failure(
        '$name box is not initialized',
        Cause('Box $name is not initialized', StackTrace.current),
      );
    }

    try {
      await box.put(pokemon.id, pokemon);
      return Result.emptySuccess();
    } catch (e, stack) {
      return Result.failure('Error saving favorite Pokémon', Cause(e, stack));
    }
  }

  Future<Result<List<PokemonFavoriteHive>>> getAll() async {
    final box = _box;
    if (box == null) {
      return Result.failure(
        '$name box is not initialized',
        Cause('Box $name is not initialized', StackTrace.current),
      );
    }

    try {
      final favorites = box.values.toList();
      return Result.success(favorites);
    } catch (e, stack) {
      return Result.failure('Error getting favorite Pokémon', Cause(e, stack));
    }
  }

  Future<EmptyResult> deleteById(String id) async {
    final box = _box;
    if (box == null) {
      return Result.failure(
        '$name box is not initialized',
        Cause('Box $name is not initialized', StackTrace.current),
      );
    }

    try {
      await box.delete(id);
      return Result.emptySuccess();
    } catch (e, stack) {
      return Result.failure('Error deleting Pokémon', Cause(e, stack));
    }
  }

  Future<bool> isFavorite(String id) async {
    final box = _box;
    if (box == null) return false;
    return box.containsKey(id);
  }

  @override
  Future<EmptyResult> delete() async {
    final box = _box;
    if (box == null) {
      return Result.failure(
        '$name box is not initialized',
        Cause('Box $name is not initialized', StackTrace.current),
      );
    }

    try {
      await box.clear();
      return Result.emptySuccess();
    } catch (e, stack) {
      return Result.failure('Error clearing favorites', Cause(e, stack));
    }
  }
}
