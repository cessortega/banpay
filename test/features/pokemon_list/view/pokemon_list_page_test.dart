import 'package:banpay/common/result.dart';
import 'package:banpay/features/pokemon_list/view/pokemon_list_page.dart';
import 'package:banpay/features/pokemon_list/provider/pokemon_list_provider.dart';
import 'package:banpay/features/pokemon_list/widgets/pokemon_grid.dart';
import 'package:banpay/widgets/favorite_widget/provider/favorite_widget_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/factory/api_factories.dart';
import '../../../test_utils/mocks/custom_mocks.dart';
import '../../../test_utils/mocks/mocks.mocks.dart';

void main() {
  testWidgets('shows loading indicator when loading', (tester) async {
    final mockUseCase = MockPokemonsUseCase();
    when(mockUseCase.call(limit: anyNamed('limit'), offset: anyNamed('offset')))
        .thenAnswer((_) async => Result.success(buildPokemonsResponse()));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pokemonsUseCaseProvider.overrideWithValue(mockUseCase),
          pokemonListProvider.overrideWith((ref) =>
              PokemonListNotifier(mockUseCase, MockRouter())
                ..state = const AsyncLoading()),
        ],
        child: const MaterialApp(home: PokemonListPage()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows no results message when filtered list is empty',
      (tester) async {
    final mockUseCase = MockPokemonsUseCase();
    when(mockUseCase.call(limit: anyNamed('limit'), offset: anyNamed('offset')))
        .thenAnswer((_) async => Result.success(buildPokemonsResponse()));

    final notifier = PokemonListNotifier(mockUseCase, MockRouter());

    notifier.state = AsyncData(buildPokemonsResponse());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pokemonListProvider.overrideWith((ref) => notifier),
          pokemonSearchProvider.overrideWith((ref) => 'zzzz'),
        ],
        child: const MaterialApp(home: PokemonListPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No se encontraron resultados'), findsOneWidget);
  });

  testWidgets('shows PokemonGrid when there are results', (tester) async {
    final mockUseCase = MockPokemonsUseCase();
    final mockFavoriteUseCase = MockPokemonFavoriteUseCase();

    when(mockUseCase.call(limit: anyNamed('limit'), offset: anyNamed('offset')))
        .thenAnswer((_) async => Result.success(buildPokemonsResponse()));

    when(mockFavoriteUseCase.isFavorite(any)).thenAnswer((_) async => false);
    when(mockFavoriteUseCase.addFavorite(any))
        .thenAnswer((_) async => Result.emptySuccess());
    when(mockFavoriteUseCase.removeFavorite(any))
        .thenAnswer((_) async => Result.emptySuccess());

    final notifier = PokemonListNotifier(mockUseCase, MockRouter());
    final response = buildPokemonsResponse();
    notifier.state = AsyncData(response);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pokemonListProvider.overrideWith((ref) => notifier),
          pokemonFavoriteUseCaseProvider.overrideWithValue(mockFavoriteUseCase),
        ],
        child: const MaterialApp(home: PokemonListPage()),
      ),
    );

    expect(find.byType(PokemonGrid), findsOneWidget);
  });
}
