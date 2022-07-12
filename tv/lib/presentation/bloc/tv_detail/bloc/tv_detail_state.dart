part of 'tv_detail_bloc.dart';

@immutable
class TvDetailState extends Equatable {
   final TvDetail? tvDetail;
  final List<Tv> tvRecommendations;
  final RequestState tvDetailState;
  final RequestState tvRecommendationState;
  final String message;
  final String watchlistMessage;
  final bool isAddedToWatchlist;

  const TvDetailState({
    required this.tvDetail,
    required this.tvRecommendations,
    required this.tvDetailState,
    required this.tvRecommendationState,
    required this.message,
    required this.watchlistMessage,
    required this.isAddedToWatchlist,
  });

  TvDetailState copyWith({
    TvDetail? tvDetail,
    List<Tv>? tvRecommendations,
    RequestState? tvDetailState,
    RequestState? tvRecommendationState,
    String? message,
    String? watchlistMessage,
    bool? isAddedToWatchlist,
  }) {
    return TvDetailState(
      tvDetail: tvDetail ?? this.tvDetail,
      tvRecommendations: tvRecommendations ?? this.tvRecommendations,
      tvDetailState: tvDetailState ?? this.tvDetailState,
      tvRecommendationState: tvRecommendationState ?? this.tvRecommendationState,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }

  factory TvDetailState.initial() {
    return const TvDetailState(
      tvDetail: null,
      tvRecommendations: [],
      tvDetailState: RequestState.Empty,
      tvRecommendationState: RequestState.Empty,
      message: '',
      watchlistMessage: '',
      isAddedToWatchlist: false,
    );
  }

  @override
  List<Object?> get props => [
    tvDetail, 
    tvRecommendations, 
    tvDetailState, 
    tvRecommendationState, 
    message, watchlistMessage, 
    isAddedToWatchlist
  ];
}
