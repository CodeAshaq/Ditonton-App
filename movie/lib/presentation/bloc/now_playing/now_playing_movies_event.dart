part of 'now_playing_movies_bloc.dart';

class NowPlayingMoviesEvent extends Equatable {
  const NowPlayingMoviesEvent();

  @override
  List<Object> get props => [];
}


class OnFetchNowPlayingMovies extends NowPlayingMoviesEvent {
  final int id;

  OnFetchNowPlayingMovies(this.id);

  @override
  List<Object> get props => [id];
}



