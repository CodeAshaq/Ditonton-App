import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/entities/tv/tvseries.dart';
import '../../../../domain/usecases/tv/get_tv_recommendations.dart';

part 'recommendation_tv_event.dart';
part 'recommendation_tv_state.dart';

class RecommendationTvBloc extends Bloc<RecommendationTvEvent, RecommendationTvState> {
 final GetTvRecommendations _getTvRecommendations;

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  RecommendationTvBloc(this._getTvRecommendations) : super(RecommendationTvEmpty()) {
    on<OnFetchRecommendationTv>((event, emit) async {
      final id = event.id;

      emit(RecommendationTvLoading());
      final result = await _getTvRecommendations.execute(id);

      result.fold(
        (failure) {
          emit(RecommendationTvError(failure.message));
        },
        (data) {
          emit(RecommendationTvHasData(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
