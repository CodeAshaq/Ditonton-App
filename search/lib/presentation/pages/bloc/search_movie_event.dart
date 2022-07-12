part of 'search_movie_bloc.dart';

abstract class SearchMovieEvent extends Equatable {
  const SearchMovieEvent();

  @override
  List<Object> get props => [];
}

class OnQueryMovieChanged extends SearchMovieEvent {
  final String query;

  OnQueryMovieChanged(this.query);

  @override
  List<Object> get props => [query];
}