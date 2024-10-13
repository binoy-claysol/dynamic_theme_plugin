// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsModel _$NewsModelFromJson(Map<String, dynamic> json) => NewsModel(
      success: json['success'] as bool,
      total: (json['total'] as num).toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => News.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NewsModelToJson(NewsModel instance) => <String, dynamic>{
      'success': instance.success,
      'total': instance.total,
      'data': instance.data,
    };

News _$NewsFromJson(Map<String, dynamic> json) => News(
      title: json['title'] as String,
      url: json['url'] as String,
      date: DateTime.parse(json['date'] as String),
      thumbnail: json['thumbnail'] as String,
      description: json['description'] as String,
      source: Source.fromJson(json['source'] as Map<String, dynamic>),
      keywords:
          (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
      authors:
          (json['authors'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
      'date': instance.date.toIso8601String(),
      'thumbnail': instance.thumbnail,
      'description': instance.description,
      'source': instance.source,
      'keywords': instance.keywords,
      'authors': instance.authors,
    };

Source _$SourceFromJson(Map<String, dynamic> json) => Source(
      name: json['name'] as String,
      url: json['url'] as String,
      favicon: json['favicon'],
    );

Map<String, dynamic> _$SourceToJson(Source instance) => <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'favicon': instance.favicon,
    };
