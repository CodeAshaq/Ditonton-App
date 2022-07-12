part of 'popular_movies_bloc.dart';

class PopularMoviesEvent extends Equatable {
  const PopularMoviesEvent();

  @override
  List<Object> get props => [];
}

class OnFetchPopularMovies extends PopularMoviesEvent {
  final int id;

  OnFetchPopularMovies(this.id);

  @override
  List<Object> get props => [id];
}



