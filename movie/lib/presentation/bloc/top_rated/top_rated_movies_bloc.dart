import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/entities/movie.dart';

part 'top_rated_movies_event.dart';
part 'top_rated_movies_state.dart';

class TopRatedMoviesBloc extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies _getTopRatedMovies;

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  TopRatedMoviesBloc(this._getTopRatedMovies) : super(TopRatedMoviesEmpty()) {
    on<TopRatedMoviesEvent>((event, emit) async {

      emit(TopRatedMoviesLoading());
      final result = await _getTopRatedMovies.execute();

      result.fold(
        (failure) {
          emit(TopRatedMoviesError(failure.message));
        },
        (data) {
          emit(TopRatedMoviesHasData(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
