import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/entities/tv/tvseries.dart';
import '../../../../domain/usecases/tv/get_now_playing_tv.dart';

part 'now_playing_tv_event.dart';
part 'now_playing_tv_state.dart';

class NowPlayingTvBloc extends Bloc<NowPlayingTvEvent, NowPlayingTvState> {
  final GetNowPlayingTv _getNowPlayingTv;

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  NowPlayingTvBloc(this._getNowPlayingTv)
      : super(NowPlayingTvEmpty()) {
    on<NowPlayingTvEvent>((event, emit) async {
      emit(NowPlayingTvLoading());
      final result = await _getNowPlayingTv.execute();

      result.fold(
        (failure) {
          emit(NowPlayingTvError(failure.message));
        },
        (data) {
          emit(NowPlayingTvHasData(data));
        },
      );
    });
  }
}


