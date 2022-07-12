part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent extends Equatable {
   const TvDetailEvent();

  @override
  List<Object?> get props => [];
}

class OnFetchTvDetail extends TvDetailEvent {
  final int id;

  const OnFetchTvDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class OnAddWatchlist extends TvDetailEvent {
  final TvDetail tv;

  const OnAddWatchlist(this.tv);

  @override
  List<Object?> get props => [tv];
}

class OnRemoveWatchlist extends TvDetailEvent {
  final TvDetail tv;

  const OnRemoveWatchlist(this.tv);

  @override
  List<Object?> get props => [tv];
}

class OnLoadWatchlistStatus extends TvDetailEvent {
  final int id;

  const OnLoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}