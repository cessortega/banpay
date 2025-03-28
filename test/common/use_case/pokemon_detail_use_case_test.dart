import 'package:banpay/common/use_case/pokemon_detail_use_case.dart';
import 'package:banpay/common/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../test_utils/mocks/mocks.mocks.dart';
import '../../test_utils/factory/api_factories.dart';

void main() {
  late PokemonDetailUseCase useCase;
  late MockPokemonDetailRepository mockRepository;

  setUp(() {
    mockRepository = MockPokemonDetailRepository();
    useCase = PokemonDetailUseCase(mockRepository);
  });

  group('PokemonDetailUseCase', () {
    const testName = 'pikachu';
    final testDetail = buildPokemonDetail();

    test('returns success when repository returns data', () async {
      when(mockRepository.getDetail(testName))
          .thenAnswer((_) async => Result.success(testDetail));

      final result = await useCase(testName);

      expect(result.isSuccess, true);
      expect(result.asSuccessOrNull()?.data.name, 'pikachu');
    });

    test('returns failure when repository throws', () async {
      when(mockRepository.getDetail(testName))
          .thenThrow(Exception('Network error'));

      final result = await useCase(testName);

      expect(result.isFailure, true);
      expect(result.asFailureOrNull()?.message,
          contains('Error fetching detail for $testName'));
    });
  });
}
