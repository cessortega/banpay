import 'dart:async';

import 'package:banpay/common/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:banpay/widgets/favorite_widget/provider/favorite_widget_provider.dart';
import 'package:banpay/api/repository/pokemons/model/pokemons.dart';
import 'package:banpay/api/repository/pokemon_favorite/model/pokemon_favorite_hive.dart';

import '../../../test_utils/factory/api_factories.dart';
import '../../../test_utils/mocks/mocks.mocks.dart';

void main() {
  late MockPokemonFavoriteUseCase mockUseCase;
  final testPokemon = buildPokemon(
    name: 'pikachu',
    url: 'https://pokeapi.co/api/v2/pokemon/25/',
  );

  setUp(() {
    mockUseCase = MockPokemonFavoriteUseCase();
  });

  test('loads favorite status correctly as true', () async {
    when(mockUseCase.isFavorite(testPokemon.id)).thenAnswer((_) async => true);

    final container = ProviderContainer(overrides: [
      pokemonFavoriteUseCaseProvider.overrideWithValue(mockUseCase),
    ]);
    addTearDown(container.dispose);

    final completer = Completer<void>();

    container.listen(
      favoriteWidgetProvider(testPokemon),
      (previous, next) {
        if (next != null && !completer.isCompleted) {
          completer.complete();
        }
      },
      fireImmediately: true,
    );

    await completer.future;

    final state = container.read(favoriteWidgetProvider(testPokemon));
    expect(state, true);
  });

  test('toggleFavorite adds to favorites when not currently favorite',
      () async {
    when(mockUseCase.isFavorite(testPokemon.id)).thenAnswer((_) async => false);
    when(mockUseCase.addFavorite(any))
        .thenAnswer((_) async => Result.emptySuccess());

    final container = ProviderContainer(overrides: [
      pokemonFavoriteUseCaseProvider.overrideWithValue(mockUseCase),
    ]);
    addTearDown(container.dispose);

    final notifier =
        container.read(favoriteWidgetProvider(testPokemon).notifier);

    await notifier.toggleFavorite();

    verify(mockUseCase.addFavorite(argThat(
      isA<PokemonFavoriteHive>()
          .having((p) => p.name, 'name', testPokemon.name)
          .having((p) => p.url, 'url', testPokemon.url),
    ))).called(1);
  });

  test('toggleFavorite removes from favorites when currently favorite',
      () async {
    when(mockUseCase.isFavorite(testPokemon.id)).thenAnswer((_) async => true);
    when(mockUseCase.removeFavorite(testPokemon.id))
        .thenAnswer((_) async => Result.emptySuccess());

    final container = ProviderContainer(overrides: [
      pokemonFavoriteUseCaseProvider.overrideWithValue(mockUseCase),
    ]);
    addTearDown(container.dispose);

    final notifier =
        container.read(favoriteWidgetProvider(testPokemon).notifier);

    notifier.state = true;

    await notifier.toggleFavorite();

    verify(mockUseCase.removeFavorite(testPokemon.id)).called(1);
  });
}
