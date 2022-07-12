import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
// import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



import '../../domain/entities/genre.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';
import '../bloc/watchlist/watchlist_movie_bloc.dart';
// import '../provider/movie_detail_notifier.dart';

class MovieDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail';

  final int id;
  MovieDetailPage({required this.id});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<MovieDetailBloc>(context, listen: false)
          .add(OnFetchMovieDetail(widget.id));
      BlocProvider.of<MovieDetailBloc>(context, listen: false)
          .add(OnLoadWatchlistStatus(widget.id));
      // Provider.of<MovieDetailNotifier>(context, listen: false)
      //     .fetchMovieDetail(widget.id);
      // Provider.of<MovieDetailNotifier>(context, listen: false)
      //     .loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
     BlocConsumer<MovieDetailBloc, MovieDetailState>(
        listener: (context, state) async {
          if (state.watchlistMessage ==
                  MovieDetailBloc.watchlistAddSuccessMessage ||
              state.watchlistMessage ==
                  MovieDetailBloc.watchlistRemoveSuccessMessage) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.watchlistMessage)));
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(state.watchlistMessage),
                  );
                });
          }
        },
        listenWhen: (previousState, currentState) =>
            previousState.watchlistMessage != currentState.watchlistMessage &&
            currentState.watchlistMessage != '',
        builder: (context, state) {
          if (state.movieDetailState == RequestState.Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.movieDetailState == RequestState.Loaded) {
            final movie = state.movieDetail;
            return SafeArea(
              child: DetailContent(
                movie!,
                state.movieRecommendations,
                state.isAddedToWatchlist,
              ),
            );
          } else if (state.movieDetailState == RequestState.Error) {
            return Text(state.message);
          } else {
            return Container(
              child: const Text(" Empty Page"),
              );
          }
        },
      ),
      // Consumer<MovieDetailNotifier>(
      //   builder: (context, provider, child) {
      //     if (provider.movieState == RequestState.Loading) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else if (provider.movieState == RequestState.Loaded) {
      //       final movie = provider.movie;
      //       return SafeArea(
      //         child: DetailContent(
      //           movie,
      //           provider.movieRecommendations,
      //           provider.isAddedToWatchlist,
      //         ),
      //       );
      //     } else {
      //       return Text(provider.message);
      //     }
      //   },
      // ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;

  DetailContent(this.movie, this.recommendations, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                  if (!isAddedWatchlist) {
                                  BlocProvider.of<MovieDetailBloc>(context,
                                          listen: false)
                                      .add(OnAddWatchlist(movie));
                                }  else {
                                  BlocProvider.of<MovieDetailBloc>(context,
                                          listen: false)
                                      .add(OnRemoveWatchlist(movie));
                                }
                                //  final message = context.select<WatchlistMovieBloc, String>((bloc) => (bloc.state is OnLoadWatchlistStatus) ? (bloc.state as OnLoadWatchlistStatus) == false ? MovieDetailBloc.watchlistAddSuccessMessage : MovieDetailBloc.watchlistRemoveSuccessMessage: '');

                                // if (message ==
                                //         MovieDetailBloc
                                //             .watchlistAddSuccessMessage ||
                                //     message ==
                                //         MovieDetailBloc
                                //             .watchlistRemoveSuccessMessage) {
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //       SnackBar(content: Text(message)));
                                // } else {
                                //   showDialog(
                                //       context: context,
                                //       builder: (context) {
                                //         return AlertDialog(
                                //           content: Text(message),
                                //         );
                                //       });
                                // }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(movie.genres),
                            ),
                            Text(
                              _showDuration(movie.runtime),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: movie.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${movie.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              movie.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<MovieDetailBloc, MovieDetailState>(
                              builder: (context, state) {
                                if (state.movieRecommendationState ==
                                    RequestState.Loading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state.movieRecommendationState ==
                                    RequestState.Error) {
                                  return Text(state.message);
                                } else if (state.movieRecommendationState ==
                                    RequestState.Loaded) {
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final movie = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                MovieDetailPage.ROUTE_NAME,
                                                arguments: movie.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
