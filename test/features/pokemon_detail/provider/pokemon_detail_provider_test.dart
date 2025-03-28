import 'package:banpay/common/result.dart';
import 'package:banpay/features/pokemon_detail/provider/pokemon_detail_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../test_utils/factory/api_factories.dart';
import '../../../test_utils/mocks/mocks.mocks.dart';

void main() {
  late MockPokemonDetailUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockPokemonDetailUseCase();
  });

  test('emits AsyncValue.data when useCase succeeds', () async {
    final detail = buildPokemonDetail(name: 'pikachu');

    when(mockUseCase.call('pikachu'))
        .thenAnswer((_) async => Result.success(detail));

    final container = ProviderContainer(
      overrides: [
        pokemonDetailUseCaseProvider.overrideWithValue(mockUseCase),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(pokemonDetailProvider('pikachu').notifier);
    await notifier.fetchDetail();

    final state = container.read(pokemonDetailProvider('pikachu'));
    expect(state, isA<AsyncData>());
    expect(state.value?.name, 'pikachu');
  });

  test('emits AsyncValue.error when useCase fails', () async {
    when(mockUseCase.call('pikachu'))
        .thenAnswer((_) async => Result.failure('Detail not found'));

    final container = ProviderContainer(
      overrides: [
        pokemonDetailUseCaseProvider.overrideWithValue(mockUseCase),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(pokemonDetailProvider('pikachu').notifier);
    await notifier.fetchDetail();

    final state = container.read(pokemonDetailProvider('pikachu'));
    expect(state, isA<AsyncError>());
    expect((state as AsyncError).error, 'Detail not found');
  });
}
