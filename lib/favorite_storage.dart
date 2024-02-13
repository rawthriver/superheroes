import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:superheroes/model/superhero.dart';

class FavoriteSuperheroesStorage {
  static const String _key = 'favorite_superheroes';

  final _updater = PublishSubject<Null>();

  static FavoriteSuperheroesStorage? _instance;
  factory FavoriteSuperheroesStorage.getInstance() => _instance ??= FavoriteSuperheroesStorage._();
  FavoriteSuperheroesStorage._();

  Future<List<String>> _getRawList() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getStringList(_key) ?? [];
  }

  Future<bool> _setRawList(final List<String> list) async {
    final sp = await SharedPreferences.getInstance();
    final result = await sp.setStringList(_key, list);
    if (result) _updater.add(null);
    return Future.value(result);
  }

  Future<List<Superhero>> _getSuperheroesList() async {
    final list = await _getRawList();
    return list.map((e) => Superhero.fromJson(json.decode(e))).toList();
  }

  Future<bool> _setSuperheroesList(final List<Superhero> heroes) async {
    final list = heroes.map((e) => json.encode(e.toJson())).toList();
    return _setRawList(list);
  }

  Future<bool> addToFavorites(final Superhero hero) async {
    final list = await _getSuperheroesList();
    list.add(hero);
    return _setSuperheroesList(list);
  }

  Future<bool> removeFromFavorites(final String id) async {
    final list = await _getSuperheroesList();
    list.removeWhere((e) => e.id == id);
    return _setSuperheroesList(list);
  }

  Future<Superhero?> getFavorite(final String id) async {
    final list = await _getSuperheroesList();
    return list.where((e) => e.id == id).firstOrNull;
  }

  Stream<List<Superhero>> observeFavorites() async* {
    yield await _getSuperheroesList();
    await for (final _ in _updater) {
      yield await _getSuperheroesList();
    }
  }

  Stream<bool> observeIsFavorite(final String id) {
    return observeFavorites().map((list) => list.any((e) => e.id == id));
  }

  void update(final Superhero hero) async {
    final list = await _getSuperheroesList();
    final index = list.indexWhere((element) => element.id == hero.id);
    if (index > -1) {
      list[index] = hero;
      _setSuperheroesList(list);
    }
  }
}
