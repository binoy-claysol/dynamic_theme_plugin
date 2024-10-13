import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'episode.g.dart';

@JsonSerializable()
class EpisodeModel {
  int id;
  String name;
  String airDate;
  String director;
  String writer;
  List<String> characters;
  String imgUrl;

  EpisodeModel({
    required this.id,
    required this.name,
    required this.airDate,
    required this.director,
    required this.writer,
    required this.characters,
    required this.imgUrl,
  });

  factory EpisodeModel.fromRawJson(String str) => EpisodeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EpisodeModel.fromJson(Map<String, dynamic> json) => EpisodeModel(
    id: json["id"],
    name: json["name"],
    airDate: json["air_date"],
    director: json["director"],
    writer: json["writer"],
    characters: List<String>.from(json["characters"].map((x) => x)),
    imgUrl: json["img_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "air_date": airDate,
    "director": director,
    "writer": writer,
    "characters": List<dynamic>.from(characters.map((x) => x)),
    "img_url": imgUrl,
  };
}
