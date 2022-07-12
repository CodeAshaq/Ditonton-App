import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/entities/movie.dart';

part 'popular_movies_event.dart';
part 'popular_movies_state.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies _getPopularMovies;

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  PopularMoviesBloc(this._getPopularMovies) : super(PopularMoviesEmpty()) {
    on<PopularMoviesEvent>((event, emit) async {

      emit(PopularMoviesLoading());
      final result = await _getPopularMovies.execute();

      result.fold(
        (failure) {
          emit(PopularMoviesError(failure.message));
        },
        (data) {
          emit(PopularMoviesHasData(data));
        },
      );
    }, 
    transformer: debounce(const Duration(milliseconds: 500))
    );
  }
}


