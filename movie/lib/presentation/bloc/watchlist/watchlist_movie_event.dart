part of 'watchlist_movie_bloc.dart';

 class WatchlistMovieEvent extends Equatable {
  const WatchlistMovieEvent();

  @override
  List<Object?> get props => [];
}


class OnFetchWatchlistMovie extends WatchlistMovieEvent {}
//   class AddWatchlist extends WatchlistMovieEvent {
//   final MovieDetail movie;

//   const AddWatchlist(this.movie);

//   @override
//   List<Object> get props => [Movie];
// }

// class RemoveWatchlist extends WatchlistMovieEvent {
//   final MovieDetail movie;

//   const RemoveWatchlist(this.movie);

//   @override
//   List<Object> get props => [Movie];
// }

// class LoadWatchlistStatus extends WatchlistMovieEvent {
//   final int id;

//   const LoadWatchlistStatus(this.id);

//   @override
//   List<Object> get props => [id];

