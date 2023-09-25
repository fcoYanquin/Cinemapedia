import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function( String query );

class SearchMovieDelegate extends SearchDelegate<Movie?> {

  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovie;

  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isloadingStream = StreamController.broadcast();
  Timer? _debaunceTimer;

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovie
  });

  void clearStreams() {
    debouncedMovies.close();
  }

  void _onQueryChanged( String query ) {

    isloadingStream.add(true);

    if (_debaunceTimer?.isActive ?? false) _debaunceTimer!.cancel();

    _debaunceTimer = Timer(const Duration(milliseconds: 500), () async {

      final movies = await searchMovies( query );
      debouncedMovies.add(movies);
      isloadingStream.add(false);
      initialMovie = movies;
    });
  }

  Widget buildResultAndSuggestions() {
    return StreamBuilder(
      initialData: initialMovie,
      stream: debouncedMovies.stream,
      builder: ((context, snapshot) {

        final movies = snapshot.data ?? [];
        
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: ((context, index) {
            return _MovieItem(
              movie: movies[index], 
              onMovieSelected: (context, movie) {
                clearStreams();
                close(context, movie);
              },
            );
          })
        ); 
      })
    );
  }



  @override
  String get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {

    return [

      StreamBuilder(
        initialData: false,
        stream: isloadingStream.stream, 
        builder: ((context, snapshot) {

          if (snapshot.data ?? false) {
            return  SpinPerfect(
              duration: const Duration(seconds: 20),
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed:() => query = '', 
                icon: const Icon(Icons.refresh_rounded)
              ),
            );
          }

          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(
              onPressed:() => query = '', 
              icon: const Icon(Icons.clear)
            ),
          );
        })
      )

    ];
  }

  ///
  /// Ir atras y cerrar la opcion de busqueda
  ///
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      }, 
      icon: const Icon(Icons.arrow_back_ios_new_rounded)
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    _onQueryChanged(query);

    return buildResultAndSuggestions();
  }

}

class _MovieItem extends StatelessWidget {

  final Movie movie;
  final Function onMovieSelected;

  const _MovieItem({
    required this.movie,
    required this.onMovieSelected
  });

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Row(
          children: [
    
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  movie.posterPath != 'no-poster' ? movie.posterPath : 'https://www.prokerala.com/movies/assets/img/no-poster-available.webp',
                  loadingBuilder: (context, child, loadingProgress) => FadeIn(child: child),
    
                ),
              ),
            ),
    
            const SizedBox(width: 10,),
    
            //Descripcion
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyle.titleMedium,),
                  (movie.overview.length > 100)
                    ? Text('${movie.overview.substring(0,100)}...')
                    : Text(movie.overview),
    
                  Row(
                    children: [
                      Icon(Icons.star_half_rounded, color: Colors.yellow.shade800,),
                      const SizedBox(width: 5,),
                      Text(
                        HumanFormats.number(movie.voteAverage, 1), 
                        style: textStyle.bodyMedium!.copyWith(color: Colors.yellow.shade900),),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}