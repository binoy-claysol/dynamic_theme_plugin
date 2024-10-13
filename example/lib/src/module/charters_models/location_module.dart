import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'location_module.g.dart';

@JsonSerializable()
class LocationModel {
  int id;
  String name;
  String type;
  List<String> inhabitants;
  List<String> notableResidents;
  String imgUrl;

  LocationModel({
    required this.id,
    required this.name,
    required this.type,
    required this.inhabitants,
    required this.notableResidents,
    required this.imgUrl,
  });

  factory LocationModel.fromRawJson(String str) => LocationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    inhabitants: List<String>.from(json["inhabitants"].map((x) => x)),
    notableResidents: List<String>.from(json["notable_residents"].map((x) => x)),
    imgUrl: json["img_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "inhabitants": List<dynamic>.from(inhabitants.map((x) => x)),
    "notable_residents": List<dynamic>.from(notableResidents.map((x) => x)),
    "img_url": imgUrl,
  };
}
