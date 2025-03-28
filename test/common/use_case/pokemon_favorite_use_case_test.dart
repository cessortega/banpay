import 'package:banpay/api/repository/pokemon_favorite/model/pokemon_favorite_hive.dart';
import 'package:banpay/common/use_case/pokemon_favorite_use_case.dart';
import 'package:banpay/common/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_utils/mocks/mocks.mocks.dart';

void main() {
  late PokemonFavoriteUseCase useCase;
  late MockPokemonFavoriteStorage mockStorage;

  setUp(() {
    mockStorage = MockPokemonFavoriteStorage();
    useCase = PokemonFavoriteUseCase.withStorage(mockStorage);
  });

  group('PokemonFavoriteUseCase', () {
    const testId = '1';
    final testPokemon = PokemonFavoriteHive(
        name: 'bulbasaur', url: 'https://pokeapi.co/api/v2/pokemon/1/');

    test('addFavorite calls storage.save', () async {
      when(mockStorage.save(any))
          .thenAnswer((_) async => Result.emptySuccess());

      final result = await useCase.addFavorite(testPokemon);

      expect(result.isSuccess, true);
      verify(mockStorage.save(testPokemon)).called(1);
    });

    test('removeFavorite calls storage.deleteById', () async {
      when(mockStorage.deleteById(any))
          .thenAnswer((_) async => Result.emptySuccess());

      final result = await useCase.removeFavorite(testId);

      expect(result.isSuccess, true);
      verify(mockStorage.deleteById(testId)).called(1);
    });

    test('isFavorite returns true when item is in storage', () async {
      when(mockStorage.isFavorite(testId)).thenAnswer((_) async => true);

      final result = await useCase.isFavorite(testId);

      expect(result, true);
      verify(mockStorage.isFavorite(testId)).called(1);
    });

    test('getFavorites returns a list', () async {
      when(mockStorage.getAll())
          .thenAnswer((_) async => Result.success([testPokemon]));

      final result = await useCase.getFavorites();

      expect(result.isSuccess, true);
      expect(result.asSuccessOrNull()?.data.length, 1);
    });

    test('clearFavorites clears storage', () async {
      when(mockStorage.delete()).thenAnswer((_) async => Result.emptySuccess());

      final result = await useCase.clearFavorites();

      expect(result.isSuccess, true);
      verify(mockStorage.delete()).called(1);
    });
  });
}
