// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'characters_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharactersModel _$CharactersModelFromJson(Map<String, dynamic> json) =>
    CharactersModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      status: json['status'] as String?,
      species: json['species'] as String?,
      gender: json['gender'] as String?,
      hair: json['hair'] as String?,
      alias:
          (json['alias'] as List<dynamic>?)?.map((e) => e as String).toList(),
      origin: json['origin'] as String?,
      abilities: (json['abilities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      img_url: json['img_url'] as String?,
    );

Map<String, dynamic> _$CharactersModelToJson(CharactersModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'species': instance.species,
      'gender': instance.gender,
      'hair': instance.hair,
      'alias': instance.alias,
      'origin': instance.origin,
      'abilities': instance.abilities,
      'img_url': instance.img_url,
    };
