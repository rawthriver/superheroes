// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:superheroes/exception/api_exception.dart';
import 'package:superheroes/favorite_storage.dart';
import 'package:superheroes/model/superhero.dart';

class SuperheroBloc {
  http.Client? client;
  final String id;

  final stateSubject = BehaviorSubject<SuperheroPageState>();
  final superheroSubject = BehaviorSubject<Superhero>();
  final BehaviorSubject<Exception> errorSubject = BehaviorSubject();

  StreamSubscription? favoriteSubscription;
  StreamSubscription? heroSubscription;

  SuperheroBloc({this.client, required this.id}) {
    _getFromFavorites();
  }

  Stream<SuperheroPageState> observeSuperheroPageState() => stateSubject.distinct();
  Stream<Superhero> observeSuperhero() => superheroSubject;
  Stream<Exception> observeErrors() => errorSubject;
  Stream<bool> observeIsFavorite() => FavoriteSuperheroesStorage.getInstance().observeIsFavorite(id);

  Future<Superhero> _makeRequest(final String id) async {
    final token = dotenv.env['SUPERHERO_TOKEN'];
    final response = await (client ??= http.Client()).get(Uri.parse('https://superheroapi.com/api/$token/$id'));
    final status = response.statusCode;
    if (status case >= 500 && < 600) {
      throw ApiException('Server error happened');
    } else if (status case >= 400 && < 500) {
      throw ApiException('Client error happened');
    } else if (status == 200) {
      final data = json.decode(response.body);
      if (data['response'] == 'error') {
        throw ApiException('Client error happened');
      } else if (data['response'] == 'success') {
        return Superhero.fromJson(data);
      }
    }
    throw Exception('Something went wrong');
  }

  void _getFromFavorites() {
    favoriteSubscription?.cancel();
    favoriteSubscription = FavoriteSuperheroesStorage.getInstance()
        .getFavorite(id)
        .asStream()
        .listen(_getSuperhero, onError: (_) => _getSuperhero(null));
  }

  void _getSuperhero(final Superhero? existing) {
    // initial state
    stateSubject.add(existing != null ? SuperheroPageState.loaded : SuperheroPageState.loading);
    if (existing != null) superheroSubject.add(existing);
    // load remote
    heroSubscription?.cancel();
    heroSubscription = _makeRequest(id).asStream().listen((result) {
      // update
      stateSubject.add(SuperheroPageState.loaded);
      if (result != existing) {
        superheroSubject.add(result);
        if (existing != null) FavoriteSuperheroesStorage.getInstance().update(result);
      }
    }, onError: (e) {
      if (existing == null) stateSubject.add(SuperheroPageState.error);
      errorSubject.add(e);
    });
  }

  void addToFavorites() {
    if (superheroSubject.hasValue) FavoriteSuperheroesStorage.getInstance().addToFavorites(superheroSubject.value);
  }

  void removeFromFavorites() {
    FavoriteSuperheroesStorage.getInstance().removeFromFavorites(id);
  }

  void retry() {
    _getSuperhero(null);
  }

  void dispose() {
    stateSubject.close();
    superheroSubject.close();
    errorSubject.close();

    favoriteSubscription?.cancel();
    heroSubscription?.cancel();

    client?.close();
  }
}

enum SuperheroPageState {
  loading,
  loaded,
  error,
}
