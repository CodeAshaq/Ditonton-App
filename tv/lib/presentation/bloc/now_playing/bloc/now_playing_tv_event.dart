part of 'now_playing_tv_bloc.dart';

class NowPlayingTvEvent extends Equatable {
  const NowPlayingTvEvent();

  @override
  List<Object> get props => [];
}


class OnFetchNowPlayingTv extends NowPlayingTvEvent {
  final int id;

  const OnFetchNowPlayingTv(this.id);

  @override
  List<Object> get props => [id];
}



