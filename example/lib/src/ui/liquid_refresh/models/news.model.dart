import 'package:json_annotation/json_annotation.dart';

part 'news.model.g.dart';

@JsonSerializable()
class NewsModel{
  bool success;
  int total;
  List<News> data;

  NewsModel({
    required this.success,
    required this.total,
    required this.data,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) =>
      _$NewsModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewsModelToJson(this);
}

@JsonSerializable()
class News {
  String title;
  String url;
  DateTime date;
  String thumbnail;
  String description;
  Source source;
  List<String> keywords;
  List<String> authors;

  News({
    required this.title,
    required this.url,
    required this.date,
    required this.thumbnail,
    required this.description,
    required this.source,
    required this.keywords,
    required this.authors,
  });
  factory News.fromJson(Map<String, dynamic> json) =>
      _$NewsFromJson(json);

  Map<String, dynamic> toJson() => _$NewsToJson(this);
}

@JsonSerializable()
class Source {
  String name;
  String url;
  dynamic favicon;

  Source({
    required this.name,
    required this.url,
    required this.favicon,
  });

  factory Source.fromJson(Map<String, dynamic> json) =>
      _$SourceFromJson(json);

  Map<String, dynamic> toJson() => _$SourceToJson(this);

}
