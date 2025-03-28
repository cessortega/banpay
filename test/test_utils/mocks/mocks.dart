import 'package:banpay/api/repository/pokemon_detail/pokemon_detail_repository.dart';
import 'package:banpay/api/repository/pokemon_favorite/pokemon_favorite_storage.dart';
import 'package:banpay/api/repository/pokemons/pokemons_repository.dart';
import 'package:banpay/common/use_case/pokemon_detail_use_case.dart';
import 'package:banpay/common/use_case/pokemon_favorite_use_case.dart';
import 'package:banpay/common/use_case/pokemons_use_case.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<PokemonsUseCase>(
      as: #MockPokemonsUseCase,
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<PokemonDetailUseCase>(
      as: #MockPokemonDetailUseCase,
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<PokemonFavoriteStorage>(
      as: #MockPokemonFavoriteStorage,
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<PokemonsRepository>(
      as: #MockPokemonsRepository,
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<PokemonDetailRepository>(
      as: #MockPokemonDetailRepository,
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<PokemonFavoriteUseCase>(
      as: #MockPokemonFavoriteUseCase,
      onMissingStub: OnMissingStub.returnDefault,
    ),
  ],
)
void main() {}
