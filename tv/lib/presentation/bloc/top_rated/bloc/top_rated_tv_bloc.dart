import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/entities/tv/tvseries.dart';
import '../../../../domain/usecases/tv/get_top_rated_tv.dart';

part 'top_rated_tv_event.dart';
part 'top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
 final GetTopRatedTv _getTopRatedTv;

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  TopRatedTvBloc(this._getTopRatedTv) : super(TopRatedTvEmpty()) {
    on<TopRatedTvEvent>((event, emit) async {

      emit(TopRatedTvLoading());
      final result = await _getTopRatedTv.execute();

      result.fold(
        (failure) {
          emit(TopRatedTvError(failure.message));
        },
        (data) {
          emit(TopRatedTvHasData(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
