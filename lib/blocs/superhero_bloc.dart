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

  final superheroSubject = BehaviorSubject<Superhero>();

  // StreamSubscription? favoriteSubscription;
  StreamSubscription? heroSubscription;

  SuperheroBloc({this.client, required this.id}) {
    _getFromFavorites();
  }

  Stream<Superhero> observeSuperhero() => superheroSubject;
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
    // favoriteSubscription?.cancel();
    FavoriteSuperheroesStorage.getInstance()
        .getFavorite(id)
        .asStream()
        .listen(_getSuperhero, onError: (_) => _getSuperhero(null));
  }

  void _getSuperhero(Superhero? existing) {
    heroSubscription?.cancel();
    heroSubscription = _makeRequest(id).asStream().listen((result) {
      FavoriteSuperheroesStorage.getInstance().update(result);
      superheroSubject.add(existing != null && result == existing ? existing : result);
    }, onError: (_) {
      if (existing != null) superheroSubject.add(existing);
    });
  }

  void addToFavorites() {
    if (superheroSubject.hasValue) FavoriteSuperheroesStorage.getInstance().addToFavorites(superheroSubject.value);
  }

  void removeFromFavorites() {
    FavoriteSuperheroesStorage.getInstance().removeFromFavorites(id);
  }

  void dispose() {
    // favoriteSubscription?.cancel();
    heroSubscription?.cancel();
    superheroSubject.close();
    client?.close();
  }
}
