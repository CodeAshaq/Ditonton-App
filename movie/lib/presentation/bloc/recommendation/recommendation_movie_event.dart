part of 'recommendation_movie_bloc.dart';

abstract class RecommendationMovieEvent extends Equatable {
  const RecommendationMovieEvent();

  @override
  List<Object> get props => [];
}

class OnFetchRecommendationMovie extends RecommendationMovieEvent {
  final int id;

  OnFetchRecommendationMovie(this.id);

  @override
  List<Object> get props => [id];
}

