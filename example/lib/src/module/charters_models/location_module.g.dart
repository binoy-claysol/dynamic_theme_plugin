// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    LocationModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      type: json['type'] as String,
      inhabitants: (json['inhabitants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      notableResidents: (json['notableResidents'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      imgUrl: json['imgUrl'] as String,
    );

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'inhabitants': instance.inhabitants,
      'notableResidents': instance.notableResidents,
      'imgUrl': instance.imgUrl,
    };
