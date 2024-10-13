import 'package:json_annotation/json_annotation.dart';

part 'characters_model.g.dart';

@JsonSerializable()
class CharactersModel {
  int id;
  String? name;
  String? status;
  String? species;
  String? gender;
  String? hair;
  List<String>? alias;
  String? origin;
  List<String>? abilities;
  String? img_url;

  CharactersModel({
    required this.id,
    this.name,
    this.status,
    this.species,
    this.gender,
    this.hair,
    this.alias,
    this.origin,
    this.abilities,
    this.img_url,
  });

  factory CharactersModel.fromJson(Map<String, dynamic> json) =>
      _$CharactersModelFromJson(json);

  Map<String, dynamic> toJson() => _$CharactersModelToJson(this);

}