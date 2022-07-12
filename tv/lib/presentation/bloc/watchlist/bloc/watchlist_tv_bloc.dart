import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/entities/tv/tvseries.dart';
import '../../../../domain/usecases/tv/get_watchlist_tv.dart';

part 'watchlist_tv_event.dart';
part 'watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
    final GetWatchlistTv _getWatchlistTv;

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }


  WatchlistTvBloc(this._getWatchlistTv) : super(WatchlistTvEmpty()) {
    on<OnFetchWatchlistTv>((event, emit) async {

      emit(WatchlistTvLoading());
      final result = await _getWatchlistTv.execute();

      result.fold(
        (failure) {
          emit(WatchlistTvError(failure.message));
        },
        (data) {
          emit(WatchlistTvHasData(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
