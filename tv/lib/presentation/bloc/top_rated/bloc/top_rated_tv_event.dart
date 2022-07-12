part of 'top_rated_tv_bloc.dart';

class TopRatedTvEvent extends Equatable {
  const TopRatedTvEvent();

  @override
  List<Object> get props => [];
}


class OnFetchTopRatedTv extends TopRatedTvEvent {
  final int id;

  OnFetchTopRatedTv(this.id);

  @override
  List<Object> get props => [id];
}

