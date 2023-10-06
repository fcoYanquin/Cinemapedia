
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/actors_datasources.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infraestructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infraestructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorMovieDbDatasource extends ActorsDatasource {

  final dio = Dio(BaseOptions(
    baseUrl: "https://api.themoviedb.org/3",
    queryParameters: {
      'api_key': Environment.theMovieDbKey,
      'language': 'es-MX'
  }));


  List<Actor> _jsonToCast( Map<String,dynamic> json ) {
    final creditsMovieDbResponse = CreditsResponse.fromJson(json);

    final List<Actor> movies = creditsMovieDbResponse.cast
    .map((actor) => ActorMapper.castToEntity(actor)).toList();

    return movies;
  }
  

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {

    final response = await dio.get('/movie/$movieId/credits');

    return _jsonToCast(response.data);

  }

}