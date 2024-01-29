// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:superheroes/exception/api_exception.dart';
import 'package:superheroes/model/superhero.dart';

class SuperheroBloc {
  http.Client? client;
  final String id;

  final superheroSubject = BehaviorSubject<Superhero>();

  StreamSubscription? heroSubscription;

  SuperheroBloc({this.client, required this.id}) {
    _getSuperhero();
  }

  Stream<Superhero> observeSuperhero() => superheroSubject;

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

  void _getSuperhero() {
    heroSubscription?.cancel();
    heroSubscription = _makeRequest(id).asStream().listen((result) {
      superheroSubject.add(result);
    }, onError: (error) {
      // errorSubject.add(error);
    });
  }

  void dispose() {
    client?.close();
    superheroSubject.close();
    heroSubscription?.cancel();
  }
}
