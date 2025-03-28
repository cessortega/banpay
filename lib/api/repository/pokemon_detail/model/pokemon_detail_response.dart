import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_detail_response.freezed.dart';
part 'pokemon_detail_response.g.dart';

@freezed
class PokemonDetailResponse with _$PokemonDetailResponse {
  const factory PokemonDetailResponse({
    required int id,
    required String name,
    required int height,
    required int weight,
    required List<PokemonStat> stats,
    required List<PokemonAbility> abilities,
    required List<PokemonTypeSlot> types,
  }) = _PokemonDetailResponse;


  factory PokemonDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonDetailResponseFromJson(json);
}

@freezed
class PokemonStat with _$PokemonStat {
  const factory PokemonStat({
    @JsonKey(name: 'base_stat') required int baseStat,
    required NamedApiResource stat,
  }) = _PokemonStat;

  factory PokemonStat.fromJson(Map<String, dynamic> json) =>
      _$PokemonStatFromJson(json);
}

@freezed
class PokemonAbility with _$PokemonAbility {
  const factory PokemonAbility({
    required NamedApiResource ability,
    @JsonKey(name: 'is_hidden') required bool isHidden,
  }) = _PokemonAbility;

  factory PokemonAbility.fromJson(Map<String, dynamic> json) =>
      _$PokemonAbilityFromJson(json);
}

@freezed
class PokemonTypeSlot with _$PokemonTypeSlot {
  const factory PokemonTypeSlot({
    required int slot,
    required NamedApiResource type,
  }) = _PokemonTypeSlot;

  factory PokemonTypeSlot.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeSlotFromJson(json);
}

@freezed
class NamedApiResource with _$NamedApiResource {
  const factory NamedApiResource({
    required String name,
    required String url,
  }) = _NamedApiResource;

  factory NamedApiResource.fromJson(Map<String, dynamic> json) =>
      _$NamedApiResourceFromJson(json);
}
