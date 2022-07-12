import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/entities/tv/tvseries.dart';
import '../../../domain/usecases/tv/get_popular_tv.dart';

part 'popular_tv_event.dart';
part 'popular_tv_state.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTv _getPopularTv;

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  PopularTvBloc(this._getPopularTv) : super(PopularTvEmpty()) {
    on<PopularTvEvent>((event, emit) async {

      emit(PopularTvLoading());
      final result = await _getPopularTv.execute();

      result.fold(
        (failure) {
          emit(PopularTvError(failure.message));
        },
        (data) {
          emit(PopularTvHasData(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}


