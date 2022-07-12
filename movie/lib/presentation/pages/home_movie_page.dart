import 'package:about/about.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/presentation/navigation/watchlist.dart';
import 'package:movie/presentation/bloc/now_playing/now_playing_movies_bloc.dart';
import 'package:movie/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:movie/presentation/bloc/top_rated/top_rated_movies_bloc.dart';
import 'package:tv/presentation/pages/tv/home_tv_page.dart';
import 'popular_movies_page.dart';
import 'top_rated_movies_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/movie.dart';
import 'movie_detail_page.dart';

class HomeMoviePage extends StatefulWidget {
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
    static const ROUTE_NAME = '/home_movie';
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask((){
        // () => Provider.of<MovieListNotifier>(context, listen: false)
        //   ..fetchNowPlayingMovies()
        //   ..fetchPopularMovies()
        //   ..fetchTopRatedMovies());
      BlocProvider.of<NowPlayingMoviesBloc>(context).add(NowPlayingMoviesEvent());
      BlocProvider.of<PopularMoviesBloc>(context).add(PopularMoviesEvent());
      BlocProvider.of<TopRatedMoviesBloc>(context).add(TopRatedMoviesEvent());

    }); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv_rounded),
              title: Text('TV Shows'),
              onTap: () {
                Navigator.pushNamed(context, HomeTVSeriesPage.ROUTE_NAME);
              },
            ),

            //sebelum
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pushNamed(context, WatchList.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton Movies'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SEARCH_ROUTE);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing',
                style: kHeading6,
              ),
               BlocBuilder<NowPlayingMoviesBloc, NowPlayingMoviesState>(builder: (context, state) {
                if (state is NowPlayingMoviesLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is NowPlayingMoviesHasData) {
                  final movie = state.result;
                  return MovieList(movie);
                } else {
                  return Text('Failed');
                }
              }),
              // Consumer<MovieListNotifier>(builder: (context, data, child) {
              //   final state = data.nowPlayingState;
              //   if (state == RequestState.Loading) {
              //     return Center(
              //       child: CircularProgressIndicator(),
              //     );
              //   } else if (state == RequestState.Loaded) {
              //     return MovieList(data.nowPlayingMovies);
              //   } else {
              //     return Text('Failed');
              //   }
              // }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
              ),
               BlocBuilder<PopularMoviesBloc, PopularMoviesState>(builder: (context, state) {
                if (state is PopularMoviesLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is PopularMoviesHasData) {
                  final movie = state.result;
                  return MovieList(movie);
                } else {
                  return Text('Failed');
                }
              }),
              // Consumer<MovieListNotifier>(builder: (context, data, child) {
              //   final state = data.popularMoviesState;
              //   if (state == RequestState.Loading) {
              //     return Center(
              //       child: CircularProgressIndicator(),
              //     );
              //   } else if (state == RequestState.Loaded) {
              //     return MovieList(data.popularMovies);
              //   } else {
              //     return Text('Failed');
              //   }
              // }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
              ),
              // Consumer<MovieListNotifier>(builder: (context, data, child) {
              //   final state = data.topRatedMoviesState;
              //   if (state == RequestState.Loading) {
              //     return Center(
              //       child: CircularProgressIndicator(),
              //     );
              //   } else if (state == RequestState.Loaded) {
              //     return MovieList(data.topRatedMovies);
              //   } else {
              //     return Text('Failed');
              //   }
              // }),
               BlocBuilder<TopRatedMoviesBloc, TopRatedMoviesState>(builder: (context, state) {
                if (state is TopRatedMoviesLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TopRatedMoviesHasData) {
                  final movie = state.result;
                  return MovieList(movie);
                } else {
                  return Text('Failed');
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  MovieList(this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  MovieDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
