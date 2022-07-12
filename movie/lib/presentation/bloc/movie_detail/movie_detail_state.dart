part of 'movie_detail_bloc.dart';

@immutable
class MovieDetailState extends Equatable {
  final MovieDetail? movieDetail;
  final List<Movie> movieRecommendations;
  final RequestState movieDetailState;
  final RequestState movieRecommendationState;
  final bool isAddedToWatchlist;
  final String message;
  final String watchlistMessage;

  const MovieDetailState({
    required this.movieDetail,
    required this.movieRecommendations,
    required this.movieDetailState,
    required this.movieRecommendationState,
    required this.isAddedToWatchlist,
    required this.message,
    required this.watchlistMessage,
  });

  MovieDetailState copyWith({
    MovieDetail? movieDetail,
    List<Movie>? movieRecommendations,
    RequestState? movieDetailState,
    RequestState? movieRecommendationState,
    bool? isAddedToWatchlist,
    String? message,
    String? watchlistMessage,
  }) {
    return MovieDetailState(
      movieDetail: movieDetail ?? this.movieDetail,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      movieDetailState: movieDetailState ?? this.movieDetailState,
      movieRecommendationState: movieRecommendationState ?? this.movieRecommendationState,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  factory MovieDetailState.initial() {
    return const MovieDetailState(
      movieDetail: null,
      movieRecommendations: [],
      movieDetailState: RequestState.Empty,
      movieRecommendationState: RequestState.Empty,
      isAddedToWatchlist: false,
      message: '',
      watchlistMessage: '',
    );
  }

  @override
  List<Object?> get props => [
    movieDetail, 
    movieRecommendations, 
    movieDetailState, 
    movieRecommendationState, 
    isAddedToWatchlist,
    message, 
    watchlistMessage, 
  ];
}
