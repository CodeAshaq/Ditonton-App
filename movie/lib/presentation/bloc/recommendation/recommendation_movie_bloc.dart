import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/entities/movie.dart';
part 'recommendation_movie_event.dart';
part 'recommendation_movie_state.dart';

class RecommendationMovieBloc extends Bloc<RecommendationMovieEvent, RecommendationMovieState> {
   final GetMovieRecommendations _getMovieRecommendations;

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  RecommendationMovieBloc(this._getMovieRecommendations) : super(RecommendationMovieEmpty()) {
    on<OnFetchRecommendationMovie>((event, emit) async {
      final id = event.id;

      emit(RecommendationMovieLoading());
      final result = await _getMovieRecommendations.execute(id);

      result.fold(
        (failure) {
          emit(RecommendationMovieError(failure.message));
        },
        (data) {
          emit(RecommendationMovieHasData(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
