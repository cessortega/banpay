import 'package:banpay/common/result.dart';
import 'package:banpay/common/route/router.dart';
import 'package:banpay/features/pokemon_list/provider/pokemon_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/factory/api_factories.dart';
import '../../../test_utils/mocks/custom_mocks.dart';
import '../../../test_utils/mocks/mocks.mocks.dart';

void main() {
  late MockPokemonsUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockPokemonsUseCase();
  });

  test('emits AsyncValue.data when useCase succeeds', () async {
    final fakeResponse = buildPokemonsResponse();

    when(mockUseCase.call(limit: anyNamed('limit'), offset: anyNamed('offset')))
        .thenAnswer((_) async => Result.success(fakeResponse));

    final container = ProviderContainer(overrides: [
      pokemonsUseCaseProvider.overrideWithValue(mockUseCase),
    ]);

    addTearDown(container.dispose);

    final notifier = container.read(pokemonListProvider.notifier);

    await notifier.fetchPokemons();

    final state = container.read(pokemonListProvider);
    expect(state, isA<AsyncData>());
    expect(state.value, fakeResponse);
  });

  test('emits AsyncValue.error when useCase fails', () async {
    when(mockUseCase.call(limit: anyNamed('limit'), offset: anyNamed('offset')))
        .thenAnswer((_) async => Result.failure('Something went wrong'));

    final container = ProviderContainer(overrides: [
      pokemonsUseCaseProvider.overrideWithValue(mockUseCase),
    ]);

    addTearDown(container.dispose);

    final notifier = container.read(pokemonListProvider.notifier);
    await notifier.fetchPokemons();

    final state = container.read(pokemonListProvider);
    expect(state, isA<AsyncError>());
    expect((state as AsyncError).error, 'Something went wrong');
  });

  test('fetchFromUrl parses offset/limit and emits AsyncValue.data', () async {
    final fakeResponse = buildPokemonsResponse();

    when(mockUseCase.call(limit: 30, offset: 0))
        .thenAnswer((_) async => Result.success(fakeResponse));

    when(mockUseCase.call(limit: 30, offset: 60))
        .thenAnswer((_) async => Result.success(fakeResponse));

    final url = buildPaginationUrl(offset: 60, limit: 30);

    final container = ProviderContainer(overrides: [
      pokemonsUseCaseProvider.overrideWithValue(mockUseCase),
    ]);
    addTearDown(container.dispose);

    final notifier = container.read(pokemonListProvider.notifier);
    await notifier.fetchFromUrl(url);

    final state = container.read(pokemonListProvider);
    expect(state, isA<AsyncData>());
    expect(state.value, fakeResponse);

    verify(mockUseCase.call(limit: 30, offset: 60)).called(1);
  });

  test('fetchFromUrl emits AsyncValue.error when useCase fails', () async {
    final fakeResponse = buildPokemonsResponse();

    when(mockUseCase.call(limit: 30, offset: 0))
        .thenAnswer((_) async => Result.success(fakeResponse));

    final url = buildPaginationUrl(offset: 90, limit: 30);

    when(mockUseCase.call(limit: 30, offset: 90))
        .thenAnswer((_) async => Result.failure('fail'));

    final container = ProviderContainer(overrides: [
      pokemonsUseCaseProvider.overrideWithValue(mockUseCase),
    ]);
    addTearDown(container.dispose);

    final notifier = container.read(pokemonListProvider.notifier);
    await notifier.fetchFromUrl(url);

    final state = container.read(pokemonListProvider);
    expect(state, isA<AsyncError>());
    expect((state as AsyncError).error, 'fail');

    verify(mockUseCase.call(limit: 30, offset: 90)).called(1);
  });

  test('onPokemonDetailClick should call router.pushTo with correct route', () {
    final fakeResponse = buildPokemonsResponse();
    final mockRouter = MockRouter();

    when(mockUseCase.call(limit: 30, offset: 0))
        .thenAnswer((_) async => Result.success(fakeResponse));

    when(mockRouter.pushTo(any)).thenAnswer((_) async => null);

    final notifier = PokemonListNotifier(mockUseCase, mockRouter);
    final testPokemon = buildPokemon(name: 'pikachu');

    notifier.onPokemonDetailClick(testPokemon);

    verify(mockRouter.pushTo(argThat(
      isA<PokemonDetailRoute>()
          .having((r) => r.pokemon.name, 'name', 'pikachu'),
    ))).called(1);
  });

  test('filteredPokemonProvider returns filtered list by name', () {
    final response = buildPokemonsResponse(
      results: [
        buildPokemon(name: 'Pikachu'),
        buildPokemon(name: 'Bulbasaur'),
        buildPokemon(name: 'Charmander'),
      ],
    );

    when(mockUseCase.call(limit: anyNamed('limit'), offset: anyNamed('offset')))
        .thenAnswer((_) async => Result.success(response));

    final mockNotifier = PokemonListNotifier(mockUseCase, MockRouter());
    mockNotifier.state = AsyncData(response);

    final container = ProviderContainer(
      overrides: [
        pokemonsUseCaseProvider.overrideWithValue(mockUseCase),
        pokemonListProvider.overrideWith((ref) => mockNotifier),
        pokemonSearchProvider.overrideWith((ref) => 'chu'),
      ],
    );

    addTearDown(container.dispose);

    final filtered = container.read(filteredPokemonProvider);

    expect(filtered.length, 1);
    expect(filtered.first.name, 'Pikachu');
  });

  test('filteredPokemonProvider returns full list on empty search', () {
    final response = buildPokemonsResponse(
      results: [
        buildPokemon(name: 'Pikachu'),
        buildPokemon(name: 'Bulbasaur'),
      ],
    );

    when(mockUseCase.call(limit: anyNamed('limit'), offset: anyNamed('offset')))
        .thenAnswer((_) async => Result.success(response));

    final mockNotifier = PokemonListNotifier(mockUseCase, MockRouter());
    mockNotifier.state = AsyncData(response);

    final container = ProviderContainer(
      overrides: [
        pokemonsUseCaseProvider.overrideWithValue(mockUseCase),
        pokemonListProvider.overrideWith((ref) => mockNotifier),
        pokemonSearchProvider.overrideWith((ref) => ''),
      ],
    );

    addTearDown(container.dispose);

    final filtered = container.read(filteredPokemonProvider);

    expect(filtered.length, 2);
  });

  test('filteredPokemonProvider returns empty list when error or loading', () {
    when(mockUseCase.call(limit: anyNamed('limit'), offset: anyNamed('offset')))
        .thenAnswer((_) async => Result.success(buildPokemonsResponse()));

    final mockNotifier = PokemonListNotifier(mockUseCase, MockRouter());
    mockNotifier.state = const AsyncLoading();

    final container = ProviderContainer(
      overrides: [
        pokemonListProvider.overrideWith((ref) => mockNotifier),
        pokemonSearchProvider.overrideWith((ref) => 'pi'),
      ],
    );

    addTearDown(container.dispose);

    final filtered = container.read(filteredPokemonProvider);

    expect(filtered, isEmpty);
  });
}
