import 'package:bloc/bloc.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../domain/entities/tv/tv_detail.dart';
import '../../../../domain/entities/tv/tvseries.dart';
import '../../../../domain/usecases/tv/get_tv_detail.dart';
import '../../../../domain/usecases/tv/get_tv_recommendations.dart';
import '../../../../domain/usecases/tv/get_watchlist_status_tv.dart';
import '../../../../domain/usecases/tv/remove_watchlist.dart';
import '../../../../domain/usecases/tv/save_watchlist.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchListStatusTv getWatchListStatus;
  final SaveWatchlistTv saveWatchlist;
  final RemoveWatchlistTv removeWatchlist;

  TvDetailBloc({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatus,
    required this.removeWatchlist,
    required this.saveWatchlist,
  }) : super(TvDetailState.initial()) {
    on<OnFetchTvDetail>((event, emit) async {
      emit(state.copyWith(tvDetailState: RequestState.Loading));

      final detailResult = await getTvDetail.execute(event.id);
      final recommendationResult =
          await getTvRecommendations.execute(event.id);

      detailResult.fold((failure) {
        emit(state.copyWith(tvDetailState: RequestState.Error));
      }, (detailData) {
        emit(state.copyWith(
          tvDetailState: RequestState.Loaded,
          tvDetail: detailData,
          tvRecommendationState: RequestState.Loading,
          message: '',
        ));
        recommendationResult.fold((failure) {
          emit(state.copyWith(tvRecommendationState: RequestState.Error));
        }, (recommendationData) {
          emit(state.copyWith(
            tvRecommendationState: RequestState.Loaded,
            tvRecommendations: recommendationData,
            message: '',
          ));
        });
      });
    });

    on<OnAddWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.tv);

      result.fold(
        (failure) {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) {
          emit(state.copyWith(watchlistMessage: successMessage));
        },
      );

      add(OnLoadWatchlistStatus(event.tv.id));
    });

    on<OnRemoveWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.tv);

      result.fold(
        (failure) {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) {
          emit(state.copyWith(watchlistMessage: successMessage));
        },
      );

      add(OnLoadWatchlistStatus(event.tv.id));
    });

    on<OnLoadWatchlistStatus>((event, emit) async {
      final result = await getWatchListStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: result));
    });
  }
}
