import 'package:banpay/api/repository/pokemon_favorite/model/pokemon_favorite_hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

import 'storage.dart';

abstract class Database {
  Database._();

  static List<Storage> _storages = [];

  static Future<void> initialize(
    List<Storage> storages, {
    DatabaseInitializer initializer = const FlutterDatabaseInitializer(),
  }) async {
    _storages = storages;
    await initializer.initialize();

    try {
      _registerOnce(PokemonFavoriteHiveAdapter());
    } catch (e) {
      Logger().e('Error registering DogsAdapter: $e');
    }

    for (final storage in storages) {
      try {
        await storage.initialize();
      } catch (e) {
        Logger().e('Failed to initialize ${storage.name}: $e');
      }
    }
  }

  static T storage<T extends Storage>() {
    final storage = _storages.firstWhere(
      (s) => s is T,
      orElse: () => throw Exception('Storage $T not found'),
    );

    return storage as T;
  }

  static void _registerOnce<T>(TypeAdapter<T> adapter) {
    if (!Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter(adapter);
    }
  }
}

abstract class DatabaseInitializer {
  const DatabaseInitializer();

  Future<void> initialize();
}

class FlutterDatabaseInitializer extends DatabaseInitializer {
  const FlutterDatabaseInitializer();

  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
  }
}
