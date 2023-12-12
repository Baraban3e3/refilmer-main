import 'dart:convert';
import 'package:refilmer/data/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:refilmer/data/repositories/movie_repository_interface.dart';

class MovieRepository implements IMovieRepository {
  final http.Client httpClient;
  final String apiKey;

  MovieRepository({required this.httpClient, required this.apiKey});

  @override
  Future<List<Movie>> getMovies(int page) async {
    try {
      String url =
          'https://api.themoviedb.org/3/discover/movie/?api_key=$apiKey&page=$page';

      final response = await httpClient.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> temp = jsonDecode(response.body)['results'];
        final result = temp.map((e) => Movie.fromJson(e)).toList();
        return result;
      } else {
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

MovieRepository initializeMovieRepository() {
  final httpClient = http.Client();
  const apiKey = 'c16f47534e8297ebabdb23f6660c16ce';
  return MovieRepository(httpClient: httpClient, apiKey: apiKey);
}
