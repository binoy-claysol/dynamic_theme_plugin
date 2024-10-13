// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FinalSpaceController on FinalSpaceControllerBase, Store {
  late final _$userDataAtom =
      Atom(name: 'FinalSpaceControllerBase.userData', context: context);

  @override
  List<dynamic> get userData {
    _$userDataAtom.reportRead();
    return super.userData;
  }

  @override
  set userData(List<dynamic> value) {
    _$userDataAtom.reportWrite(value, super.userData, () {
      super.userData = value;
    });
  }

  late final _$episodesAtom =
      Atom(name: 'FinalSpaceControllerBase.episodes', context: context);

  @override
  List<EpisodeModel> get episodes {
    _$episodesAtom.reportRead();
    return super.episodes;
  }

  @override
  set episodes(List<EpisodeModel> value) {
    _$episodesAtom.reportWrite(value, super.episodes, () {
      super.episodes = value;
    });
  }

  late final _$charactersAtom =
      Atom(name: 'FinalSpaceControllerBase.characters', context: context);

  @override
  List<CharactersModel> get characters {
    _$charactersAtom.reportRead();
    return super.characters;
  }

  @override
  set characters(List<CharactersModel> value) {
    _$charactersAtom.reportWrite(value, super.characters, () {
      super.characters = value;
    });
  }

  late final _$locationsAtom =
      Atom(name: 'FinalSpaceControllerBase.locations', context: context);

  @override
  List<LocationModel> get locations {
    _$locationsAtom.reportRead();
    return super.locations;
  }

  @override
  set locations(List<LocationModel> value) {
    _$locationsAtom.reportWrite(value, super.locations, () {
      super.locations = value;
    });
  }

  late final _$selectedIndexAtom =
      Atom(name: 'FinalSpaceControllerBase.selectedIndex', context: context);

  @override
  int get selectedIndex {
    _$selectedIndexAtom.reportRead();
    return super.selectedIndex;
  }

  @override
  set selectedIndex(int value) {
    _$selectedIndexAtom.reportWrite(value, super.selectedIndex, () {
      super.selectedIndex = value;
    });
  }

  late final _$getCharactersAsyncAction =
      AsyncAction('FinalSpaceControllerBase.getCharacters', context: context);

  @override
  Future<List<CharactersModel>> getCharacters() {
    return _$getCharactersAsyncAction.run(() => super.getCharacters());
  }

  late final _$getEpisodeAsyncAction =
      AsyncAction('FinalSpaceControllerBase.getEpisode', context: context);

  @override
  Future<List<EpisodeModel>> getEpisode() {
    return _$getEpisodeAsyncAction.run(() => super.getEpisode());
  }

  late final _$getLocationAsyncAction =
      AsyncAction('FinalSpaceControllerBase.getLocation', context: context);

  @override
  Future<List<LocationModel>> getLocation() {
    return _$getLocationAsyncAction.run(() => super.getLocation());
  }

  @override
  String toString() {
    return '''
userData: ${userData},
episodes: ${episodes},
characters: ${characters},
locations: ${locations},
selectedIndex: ${selectedIndex}
    ''';
  }
}
