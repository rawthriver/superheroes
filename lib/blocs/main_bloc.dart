// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:rxdart/rxdart.dart';

//API key: 7030337270418237

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
    // initial page
    stateSubject.add(MainPageState.noFavorites);
    // listen for input events
    textSubscription = Rx.combineLatest2(
        currentTextSubject.distinct().debounceTime(const Duration(milliseconds: 500)),
        favoriteSuperheroesSubject,
        (text, favorites) => MainPageStateInfo(searchText: text, hasFavorites: favorites.isNotEmpty)).listen((value) {
      // print('Text = $text');
      searchSubscription?.cancel();
      if (value.searchText.isEmpty) {
        // alternative to combining streams
        // stateSubject.add(favoriteSuperheroesSubject.hasValue && favoriteSuperheroesSubject.value.isNotEmpty
        //     ? MainPageState.favorites
        //     : MainPageState.noFavorites);
        stateSubject.add(value.hasFavorites ? MainPageState.favorites : MainPageState.noFavorites);
      } else if (value.searchText.length < minSymbols) {
        stateSubject.add(MainPageState.minSymbols);
      } else {
        _searchForSuperheroes(value.searchText);
      }
    });
  }

  Future<List<SuperheroInfo>> search(final String text) async {
    await Future.delayed(const Duration(seconds: 1));
    var s = text.toLowerCase();
    return SuperheroInfo.mocked.where((item) => item.name.toLowerCase().contains(s)).toList();
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

  void updateSearchText(final String? text) {
    currentTextSubject.add(text ?? '');
  }

  void removeFavorite() {
    if (favoriteSuperheroesSubject.hasValue && favoriteSuperheroesSubject.value.isNotEmpty) {
      favoriteSuperheroesSubject.add(favoriteSuperheroesSubject.value.toList()..removeLast());
      // if (favoriteSuperheroesSubject.value.isEmpty) stateSubject.add(MainPageState.noFavorites);
    } else {
      favoriteSuperheroesSubject.add(SuperheroInfo.mocked);
    }
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
