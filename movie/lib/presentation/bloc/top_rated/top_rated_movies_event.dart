part of 'top_rated_movies_bloc.dart';

class TopRatedMoviesEvent extends Equatable {
  const TopRatedMoviesEvent();

  @override
  List<Object> get props => [];
}


class OnFetchTopRatedMovies extends TopRatedMoviesEvent {
  final int id;

  OnFetchTopRatedMovies(this.id);

  @override
  List<Object> get props => [id];
}

