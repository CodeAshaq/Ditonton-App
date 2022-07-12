import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/entities/movie.dart';

part 'now_playing_movies_event.dart';
part 'now_playing_movies_state.dart';

class NowPlayingMoviesBloc extends Bloc<NowPlayingMoviesEvent, NowPlayingMoviesState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  NowPlayingMoviesBloc(this._getNowPlayingMovies)
      : super(NowPlayingMoviesEmpty()) {
    on<NowPlayingMoviesEvent>((event, emit) async {
      emit(NowPlayingMoviesLoading());
      final result = await _getNowPlayingMovies.execute();

      result.fold(
        (failure) {
          emit(NowPlayingMoviesError(failure.message));
        },
        (data) {
          emit(NowPlayingMoviesHasData(data));
        },
      );
    },transformer: debounce(const Duration(milliseconds: 500))
    );
  }
}


