part of 'recommendation_tv_bloc.dart';

class RecommendationTvEvent extends Equatable {
  const RecommendationTvEvent();

  @override
  List<Object> get props => [];
}

class OnFetchRecommendationTv extends RecommendationTvEvent {
  final int id;

  OnFetchRecommendationTv(this.id);

  @override
  List<Object> get props => [id];
}

