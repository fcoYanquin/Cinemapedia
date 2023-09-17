import 'package:cinemapedia/presentation/providers/provider.dart';
import 'package:cinemapedia/presentation/widgetss/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottonNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {

  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
  }

  @override
  Widget build(BuildContext context) {

    final initialLoading = ref.watch(initialLoadingProvider);
    if ( initialLoading) return const FullScreenLoader();

    final slideShowMovies = ref.watch( moviesSlideshowProvider );
    final nowPlayinMovies = ref.watch( nowPlayingMoviesProvider );
    final popularMovies = ref.watch( popularMoviesProvider );
    final topRatedMovies = ref.watch( topRatedMoviesProvider );
    final upcomingMovies = ref.watch( upcomingMoviesProvider );

    return CustomScrollView(
      slivers: [

        const SliverAppBar(
          floating: true,
          flexibleSpace: CustomAppbar(),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return  Column(            
              children: [
    
                MoviesSlideshow(movies: slideShowMovies),
          
                MovieHorizontalListview(
                  movies: nowPlayinMovies,
                  title: "En cines",
                  subTitle: "18 Septiembre",
                  loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
                ),
          
                MovieHorizontalListview(
                  movies: popularMovies,
                  title: "Populares",
                  subTitle: "Este mes",
                  loadNextPage: () => ref.read(popularMoviesProvider.notifier).loadNextPage(),
                ),
          
                MovieHorizontalListview(
                  movies: topRatedMovies,
                  title: "Mejor Calificadas",
                  loadNextPage: () => ref.read(topRatedMoviesProvider.notifier).loadNextPage(),
                ),
          
                MovieHorizontalListview(
                  movies: upcomingMovies,
                  title: "Proximamente",
                  subTitle: "En Cines",
                  loadNextPage: () => ref.read(upcomingMoviesProvider.notifier).loadNextPage(),
                ),

                const SizedBox(height: 30,)
    
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: nowPlayinMovies.length,
                //     itemBuilder: (context, index) {
                //       final movie = nowPlayinMovies[index];
                //       return ListTile(
                //         title: Text( movie.title ),
                //       );
                //     },
                //   ),
                // )
              ],        
            );    
          },
          childCount: 1)
        )

      ],
      
    );
  }
}
