// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import 'package:superheroes/exception/api_exception.dart';
import 'package:superheroes/favorite_storage.dart';
import 'package:superheroes/model/alignment_info.dart';
import 'package:superheroes/model/superhero.dart';

class MainBloc {
  static const int minSymbols = 3;

  final BehaviorSubject<MainPageState> stateSubject = BehaviorSubject();
  final BehaviorSubject<Exception> errorSubject = BehaviorSubject();
  final BehaviorSubject<List<SuperheroInfo>> searchedSuperheroesSubject = BehaviorSubject();
  final BehaviorSubject<String> currentTextSubject = BehaviorSubject.seeded('');

  StreamSubscription? textSubscription;
  StreamSubscription? searchSubscription;

  Stream<MainPageState> observeState() => stateSubject;
  Stream<Exception> observeErrors() => errorSubject;
  Stream<List<SuperheroInfo>> observeFavorites() {
    return FavoriteSuperheroesStorage.getInstance()
        .observeFavorites()
        .map((heroes) => heroes.map((hero) => SuperheroInfo.fromSuperhero(hero)).toList());
  }

  Stream<List<SuperheroInfo>> observeSearched() => searchedSuperheroesSubject;

  http.Client? client;

  MainBloc({this.client}) {
    // initial page
    stateSubject.add(MainPageState.loading);
    // listen for input events
    textSubscription = Rx.combineLatest2(
        currentTextSubject.distinct().debounceTime(const Duration(milliseconds: 500)),
        FavoriteSuperheroesStorage.getInstance().observeFavorites(),
        (text, favorites) => MainPageStateInfo(searchText: text, hasFavorites: favorites.isNotEmpty)).listen((value) {
      searchSubscription?.cancel();
      if (value.searchText.isEmpty) {
        stateSubject.add(value.hasFavorites ? MainPageState.favorites : MainPageState.noFavorites);
      } else if (value.searchText.length < minSymbols) {
        stateSubject.add(MainPageState.minSymbols);
      } else {
        _searchForSuperheroes(value.searchText);
      }
    });
  }

  Future<List<SuperheroInfo>> _doSearch(final String text) async {
    final token = dotenv.env['SUPERHERO_TOKEN'];
    final response =
        await (client ??= http.Client()).get(Uri.parse('https://superheroapi.com/api/$token/search/$text'));
    final status = response.statusCode;
    if (status case >= 500 && < 600) {
      throw ApiException('Server error happened');
    } else if (status case >= 400 && < 500) {
      throw ApiException('Client error happened');
    } else if (status == 200) {
      final data = json.decode(response.body);
      if (data['response'] == 'error') {
        if (data['error'] != 'character with given name not found') {
          throw ApiException('Client error happened');
        } else {
          return [];
        }
      } else if (data['response'] == 'success') {
        final list = data['results'] as List;
        return list.map((json) => Superhero.fromJson(json)).map(SuperheroInfo.fromSuperhero).toList();
      }
    }
    throw Exception('Something went wrong');
  }

  void _searchForSuperheroes(final String text) {
    stateSubject.add(MainPageState.loading);
    searchSubscription = _doSearch(text).asStream().listen((results) {
      if (results.isEmpty) {
        stateSubject.add(MainPageState.nothingFound);
      } else {
        searchedSuperheroesSubject.add(results);
        stateSubject.add(MainPageState.searchResults);
      }
    }, onError: (error) {
      errorSubject.add(error);
      stateSubject.add(MainPageState.loadingError);
    });
  }

  void retry() {
    searchSubscription?.cancel();
    _searchForSuperheroes(currentTextSubject.value);
  }

  void updateSearchText(final String? text) {
    currentTextSubject.add(text ?? '');
  }

  removeSuperhero(String id) {
    FavoriteSuperheroesStorage.getInstance().removeFromFavorites(id);
  }

  void dispose() {
    stateSubject.close();
    errorSubject.close();
    searchedSuperheroesSubject.close();
    currentTextSubject.close();

    textSubscription?.cancel();
    searchSubscription?.cancel();

    client?.close();
  }
}

enum MainPageState {
  noFavorites,
  minSymbols,
  loading,
  nothingFound,
  loadingError,
  searchResults,
  favorites,
}

class SuperheroInfo {
  final String id;
  final String name;
  final String realName;
  final String imageUrl;
  final AlignmentInfo? alignment;

  const SuperheroInfo({
    required this.id,
    required this.name,
    required this.realName,
    required this.imageUrl,
    this.alignment,
  });

  @override
  bool operator ==(covariant SuperheroInfo other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.realName == realName && other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ realName.hashCode ^ imageUrl.hashCode;
  }

  @override
  String toString() {
    return 'SuperheroInfo(id: $id, name: $name, realName: $realName, imageUrl: $imageUrl)';
  }

  static const mocked = [
    SuperheroInfo(
      id: '70',
      name: 'Batman',
      realName: 'Bruce Wayne',
      imageUrl: 'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
    ),
    SuperheroInfo(
      id: '732',
      name: 'Ironman',
      realName: 'Tony Stark',
      imageUrl: 'https://www.superherodb.com/pictures2/portraits/10/100/85.jpg',
    ),
    SuperheroInfo(
      id: '687',
      name: 'Venom',
      realName: 'Eddie Brock',
      imageUrl: 'https://www.superherodb.com/pictures2/portraits/10/100/22.jpg',
    ),
  ];

  factory SuperheroInfo.fromSuperhero(final Superhero hero) {
    return SuperheroInfo(
      id: hero.id,
      name: hero.name,
      realName: hero.biography.fullName,
      imageUrl: hero.image.url,
      alignment: hero.biography.alignmentInfo,
    );
  }
}

class MainPageStateInfo {
  final String searchText;
  final bool hasFavorites;

  const MainPageStateInfo({
    required this.searchText,
    required this.hasFavorites,
  });

  @override
  bool operator ==(covariant MainPageStateInfo other) {
    if (identical(this, other)) return true;

    return other.searchText == searchText && other.hasFavorites == hasFavorites;
  }

  @override
  int get hashCode => searchText.hashCode ^ hasFavorites.hashCode;
}
