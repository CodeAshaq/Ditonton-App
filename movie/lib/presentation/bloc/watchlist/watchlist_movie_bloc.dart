import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';
// import 'package:movie/domain/usecases/get_watchlist_status.dart';
// import 'package:movie/domain/usecases/remove_watchlist.dart';
// import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/entities/movie.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

class WatchlistMovieBloc extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies _getWatchlistMovies;

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }


  WatchlistMovieBloc(this._getWatchlistMovies) : super(WatchlistMovieEmpty()) {
    on<OnFetchWatchlistMovie>((event, emit) async {

      emit(WatchlistMovieLoading());
      final result = await _getWatchlistMovies.execute();

      result.fold(
        (failure) {
          emit(WatchlistMovieError(failure.message));
        },
        (data) {
          emit(WatchlistMovieHasData(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
