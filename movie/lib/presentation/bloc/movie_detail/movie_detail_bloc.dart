import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/entities/movie_detail.dart';
import '../../../domain/usecases/get_movie_recommendations.dart';
import '../../../domain/usecases/get_watchlist_status.dart';
import '../../../domain/usecases/remove_watchlist.dart';
import '../../../domain/usecases/save_watchlist.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';


class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;
  final GetWatchListStatus getWatchListStatus;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.removeWatchlist,
    required this.saveWatchlist,
  }) : super(MovieDetailState.initial()) {
    on<OnFetchMovieDetail>((event, emit) async {
      emit(state.copyWith(movieDetailState: RequestState.Loading));

      final detailResult = await getMovieDetail.execute(event.id);
      final recommendationResult =
          await getMovieRecommendations.execute(event.id);

      detailResult.fold((failure) {
        emit(state.copyWith(movieDetailState: RequestState.Error));
      }, (detailData) {
        emit(state.copyWith(
          movieDetailState: RequestState.Loaded,
          movieDetail: detailData,
          movieRecommendationState: RequestState.Loading,
          message: '',
        ));
        recommendationResult.fold((failure) {
          emit(state.copyWith(movieRecommendationState: RequestState.Error));
        }, (recommendationData) {
          emit(state.copyWith(
            movieRecommendationState: RequestState.Loaded,
            movieRecommendations: recommendationData,
            message: '',
          ));
        });
      });
    });

    on<OnAddWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.movie);

      result.fold(
        (failure) {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) {
          emit(state.copyWith(watchlistMessage: successMessage));
        },
      );

      add(OnLoadWatchlistStatus(event.movie.id));
    });

    on<OnRemoveWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.movie);

      result.fold(
        (failure) {
          emit(state.copyWith(watchlistMessage: failure.message));
        },
        (successMessage) {
          emit(state.copyWith(watchlistMessage: successMessage));
        },
      );

      add(OnLoadWatchlistStatus(event.movie.id));
    });

    on<OnLoadWatchlistStatus>((event, emit) async {
      final result = await getWatchListStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: result));
    });
  }
}
