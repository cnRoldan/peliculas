import 'dart:async';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = 'a209d182cd582ca865384560ce0e95f1';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';
  final String apiVersion = '3';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  final StreamController<List<Movie>> _suggestionStreamController = StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _suggestionStreamController.stream;

  MoviesProvider() {
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String path, [int page = 1]) async {
    final url = Uri.https(_baseUrl, path, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    // Await the http get response, then decode the json-formatted response.
    final response = await _getJsonData('$apiVersion/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(response);

    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    final response = await _getJsonData('$apiVersion/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(response);

    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    //Revisar el mapa para saber si está pristine.
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final jsonData = await _getJsonData('$apiVersion/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url =
        Uri.https(_baseUrl, '$apiVersion/search/movie', {'api_key': _apiKey, 'language': _language, 'query': query});

    final response = await http.get(url);
    final searchMovieResponse = SearchMovieResponse.fromJson(response.body);
    return searchMovieResponse.results;
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await searchMovies(value);
      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301)).then((value) => timer.cancel());
  }
}
