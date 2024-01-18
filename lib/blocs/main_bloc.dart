// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:rxdart/rxdart.dart';

class MainBloc {
  static const int minSymbols = 3;

  final BehaviorSubject<MainPageState> stateSubject = BehaviorSubject();
  final BehaviorSubject<List<SuperheroInfo>> favoriteSuperheroesSubject = BehaviorSubject.seeded(SuperheroInfo.mocked);
  final BehaviorSubject<List<SuperheroInfo>> searchedSuperheroesSubject = BehaviorSubject();
  final BehaviorSubject<String> currentTextSubject = BehaviorSubject.seeded('');

  StreamSubscription? textSubscription;
  StreamSubscription? searchSubscription;

  Stream<MainPageState> observeMainPageState() => stateSubject;
  Stream<List<SuperheroInfo>> observeFavorites() => favoriteSuperheroesSubject;
  Stream<List<SuperheroInfo>> observeSearched() => searchedSuperheroesSubject;

  MainBloc() {
    stateSubject.add(MainPageState.noFavorites);
    textSubscription = currentTextSubject.listen((value) {
      searchSubscription?.cancel();
      if (value.isEmpty) {
        stateSubject.add(MainPageState.favorites);
      } else if (value.length < minSymbols) {
        stateSubject.add(MainPageState.minSymbols);
      } else {
        _searchForSuperheroes(value);
      }
    });
  }

  Future<List<SuperheroInfo>> search(final String text) async {
    await Future.delayed(const Duration(seconds: 2));
    return SuperheroInfo.mocked.reversed.toList();
  }

  void _searchForSuperheroes(final String text) {
    stateSubject.add(MainPageState.loading);
    searchSubscription = search(text).asStream().listen((results) {
      if (results.isEmpty) {
        stateSubject.add(MainPageState.nothingFound);
      } else {
        searchedSuperheroesSubject.add(results);
        stateSubject.add(MainPageState.searchResults);
      }
    }, onError: (error) {
      stateSubject.add(MainPageState.loadingError);
    });
  }

  void nextState() {
    final currentState = stateSubject.value;
    final MainPageState nextState =
        MainPageState.values[(MainPageState.values.indexOf(currentState) + 1) % MainPageState.values.length];
    stateSubject.add(nextState);
  }

  void updateSearchText(final String? text) {
    currentTextSubject.add(text ?? '');
  }

  void dispose() {
    stateSubject.close();
    favoriteSuperheroesSubject.close();
    searchedSuperheroesSubject.close();
    currentTextSubject.close();
    textSubscription?.cancel();
    searchSubscription?.cancel();
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
  final String name;
  final String realName;
  final String imageUrl;

  const SuperheroInfo({
    required this.name,
    required this.realName,
    required this.imageUrl,
  });

  @override
  bool operator ==(covariant SuperheroInfo other) {
    if (identical(this, other)) return true;
    return other.name == name && other.realName == realName && other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => name.hashCode ^ realName.hashCode ^ imageUrl.hashCode;

  static const mocked = [
    SuperheroInfo(
      name: 'Batman',
      realName: 'Bruce Wayne',
      imageUrl: 'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
    ),
    SuperheroInfo(
      name: 'Ironman',
      realName: 'Tony Stark',
      imageUrl: 'https://www.superherodb.com/pictures2/portraits/10/100/85.jpg',
    ),
    SuperheroInfo(
      name: 'Venom',
      realName: 'Eddie Brock',
      imageUrl: 'https://www.superherodb.com/pictures2/portraits/10/100/22.jpg',
    ),
  ];
}
