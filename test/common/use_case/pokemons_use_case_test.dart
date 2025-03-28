import 'package:banpay/common/result.dart';
import 'package:banpay/common/use_case/pokemons_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_utils/factory/api_factories.dart';
import '../../test_utils/mocks/mocks.mocks.dart';

void main() {
  late PokemonsUseCase useCase;
  late MockPokemonsRepository mockRepository;

  const defaultLimit = 30;
  const defaultOffset = 0;

  setUp(() {
    mockRepository = MockPokemonsRepository();
    useCase = PokemonsUseCase(mockRepository);
  });

  group('PokemonsUseCase', () {
    test('returns Result.success from repository', () async {
      final fakeResponse = buildPokemonsResponse(results: [
        buildPokemon(
            name: 'pikachu', url: 'https://pokeapi.co/api/v2/pokemon/25/'),
      ]);

      when(mockRepository.getPokemons(
              limit: defaultLimit, offset: defaultOffset))
          .thenAnswer((_) async => Result.success(fakeResponse));

      final result = await useCase(limit: defaultLimit, offset: defaultOffset);

      expect(result.isSuccess, true);
      expect(result.asSuccessOrNull()?.data.results.first.name, 'pikachu');
      verify(mockRepository.getPokemons(
              limit: defaultLimit, offset: defaultOffset))
          .called(1);
    });

    test('returns Result.failure when repository throws', () async {
      when(mockRepository.getPokemons(
              limit: defaultLimit, offset: defaultOffset))
          .thenThrow(Exception('Network error'));

      final result = await useCase(limit: defaultLimit, offset: defaultOffset);

      expect(result.isFailure, true);
      expect(result.asFailureOrNull()?.message,
          contains('Error fetching pokemons in PokemonsUseCase'));
    });
  });
}
