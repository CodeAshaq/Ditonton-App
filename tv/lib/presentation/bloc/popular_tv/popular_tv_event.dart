part of 'popular_tv_bloc.dart';

class PopularTvEvent extends Equatable {
 const PopularTvEvent();

  @override
  List<Object> get props => [];
}

class OnFetchPopularTv extends PopularTvEvent {
  final int id;

  const OnFetchPopularTv(this.id);

  @override
  List<Object> get props => [id];
}



