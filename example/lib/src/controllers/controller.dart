
import 'dart:developer';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:example/src/module/charters_models/characters_model.dart';
import 'package:example/src/module/charters_models/episode.dart';
import 'package:example/src/module/charters_models/location_module.dart';

import '../ui/liquid_refresh/models/news.model.dart';





part 'controller.g.dart';

class FinalSpaceController = FinalSpaceControllerBase with _$FinalSpaceController;
abstract class FinalSpaceControllerBase with Store {

  final Dio dio = Dio();

  @observable
  List<dynamic> userData =[];

  @observable
  List<EpisodeModel> episodes =[];

  @observable
  List<CharactersModel> characters = [];

  @observable
  List<LocationModel> locations = [];

  @observable
  int selectedIndex= 0;

  @observable
  ObservableList<News> newsList = ObservableList();

  @observable
  bool isLoading = false;

  @action
  Future<void> getNews(String location) async {
    try { isLoading=true;
    log('Fetching News...');
    final response = await dio.get('https://google-news22.p.rapidapi.com/v1/geolocation?country=us&language=en&location=$location',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'X-RapidAPI-Key': 'c7e57964efmsh17f7bdc514e3ebfp1d09ecjsnf1f008b6c1ab',
          'X-RapidAPI-Host': 'google-news22.p.rapidapi.com',
        },
      ),);
    log("entered-1");
    if (response.statusCode == 200 ) {
      print("entered");
      var data = response.data;
      NewsModel newsModel = NewsModel.fromJson(data);
      newsList = ObservableList<News>.of(newsModel.data);
      print(newsList);
      isLoading=false;
    } else {
      throw Exception('Failed to load characters');
    }
    } catch (e) {
      throw Exception('Failed to load characters: $e');
    }

  }

  @action
  Future<List<CharactersModel>> getCharacters() async {
    try {
      log('Fetching characters...');
      final response = await dio.get('https://finalspaceapi.com/api/v0/character');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<CharactersModel> characters =
        data.map((json) => CharactersModel.fromJson(json)).toList();
        return characters;
      } else {
        throw Exception('Failed to load characters');
      }
    } catch (e) {
      throw Exception('Failed to load characters: $e');
    }
  }

  @action
  Future<List<EpisodeModel>> getEpisode() async {
    try {
      log('Fetching characters...');
      final response = await dio.get('https://finalspaceapi.com/api/v0/episode');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<EpisodeModel> episodes =
        data.map((json) => EpisodeModel.fromJson(json)).toList();
        return episodes;
      } else {
        throw Exception('Failed to load characters');
      }
    } catch (e) {
      throw Exception('Failed to load characters: $e');
    }
  }

  @action
  Future<List<LocationModel>> getLocation() async {
    try {
      log('Fetching characters...');
      final response = await dio.get('https://finalspaceapi.com/api/v0/location');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final List<LocationModel> locations =
        data.map((json) => LocationModel.fromJson(json)).toList();
        return locations;
      } else {
        throw Exception('Failed to load characters');
      }
    } catch (e) {
      throw Exception('Failed to load characters: $e');
    }
  }


}