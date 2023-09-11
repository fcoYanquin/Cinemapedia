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
  }

  @override
  Widget build(BuildContext context) {

    final nowPlayinMovies = ref.watch( nowPlayingMoviesProvider );
    final slideShowMovies = ref.watch( moviesSlideshowProvider );


    return CustomScrollView(
      slivers: [

        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
          ),
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
                  movies: nowPlayinMovies,
                  title: "Próximamente",
                  subTitle: "Este mes",
                  loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
                ),
          
                MovieHorizontalListview(
                  movies: nowPlayinMovies,
                  title: "Populares",
                  loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
                ),
          
                MovieHorizontalListview(
                  movies: nowPlayinMovies,
                  title: "Mejor calificadas",
                  subTitle: "De todos los tiempos",
                  loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextPage(),
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
