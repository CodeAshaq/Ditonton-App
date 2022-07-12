import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:movie/domain/entities/genre.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv/tv_detail.dart';
import 'package:tv/domain/entities/tv/tvseries.dart';
import 'package:tv/presentation/bloc/tv_detail/bloc/tv_detail_bloc.dart';

import '../../dummy_data/tv/dummy_objects_tv.dart';
import '../../helpers/tv/bloc_helper.mocks.dart';


void main() {
  late TvDetailBloc bloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchListStatusTv mockGetWatchlistStatus;
  late MockSaveWatchlistTv mockSaveWatchlist;
  late MockRemoveWatchlistTv mockRemoveWatchlist;
      late int listenerCallCount;



  setUp(() {
    mockGetTvDetail = MockGetTvDetail();

    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatusTv();
    mockSaveWatchlist = MockSaveWatchlistTv();
    mockRemoveWatchlist = MockRemoveWatchlistTv();
    bloc = TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  final tId = 1;
  final tvDetailStateInit = TvDetailState.initial();
  final tTv = Tv(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTvSeries = <Tv>[tTv];

  final tTvDetail = TvDetail(
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalName: 'originalName',
  overview: 'overview',
  posterPath: 'posterPath',
  firstAirDate: 'firstAirDate',
  name: 'name',
  voteAverage: 1,
  voteCount: 1,
  );


  group(
    'Get Tv Detail',
    () {
      blocTest<TvDetailBloc, TvDetailState>(
        'Should change Tv when data is gotten succesfully',
        build: () {
          when(mockGetTvDetail.execute(tId))
              .thenAnswer((_) async => Right(testTvDetail));
          when(mockGetTvRecommendations.execute(tId))
              .thenAnswer((_) async => Right(tTvSeries));
          return bloc;
        },
        act: (bloc) => bloc.add( OnFetchTvDetail(tId)),
        wait:  Duration(milliseconds: 500),
        expect: () => [
          tvDetailStateInit.copyWith(tvDetailState: RequestState.Loading),
          tvDetailStateInit.copyWith(
            tvRecommendationState: RequestState.Loading,
            tvDetail: tTvDetail,
            tvDetailState: RequestState.Loaded,
            message: '',
          ),
          tvDetailStateInit.copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: tTvDetail,
            tvRecommendationState: RequestState.Loaded,
            tvRecommendations: tTvSeries,
            message: '',
          ),
        ],
        verify: (bloc) {
          mockGetTvDetail.execute(tId);
          mockGetTvRecommendations.execute(tId);
        },
      );
      blocTest<TvDetailBloc, TvDetailState>(
        'Should return Error when data is failed',
        build: () {
          when(mockGetTvDetail.execute(tId)).thenAnswer(
              (_) async =>  Left(ServerFailure('Server Failure')));
          when(mockGetTvRecommendations.execute(tId)).thenAnswer(
              (_) async =>  Left(ServerFailure('Server Failure')));
          return bloc;
        },
        act: (bloc) => bloc.add( OnFetchTvDetail(tId)),
        wait:  Duration(milliseconds: 500),
        expect: () => [
          tvDetailStateInit.copyWith(tvDetailState: RequestState.Loading),
          tvDetailStateInit.copyWith(
            tvRecommendationState: RequestState.Empty,
            tvDetailState: RequestState.Error,
          ),
        ],
        verify: (bloc) {
          mockGetTvDetail.execute(tId);
        },
      );
    },
  );

  group(
    'Watchlist',
    () {
      blocTest<TvDetailBloc, TvDetailState>(
        'Should get the watchlist status',
        build: () {
          when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
          return bloc;
        },
        act: (bloc) => bloc.add( OnLoadWatchlistStatus(tId)),
        wait:  Duration(milliseconds: 500),
        expect: () => [
          tvDetailStateInit.copyWith(isAddedToWatchlist: true),
        ],
        verify: (bloc) {
          mockGetWatchlistStatus.execute(1);
        },
      );
      blocTest<TvDetailBloc, TvDetailState>(
        'Should emit watchlistmessage and add the watchlist when added to watchlist',
        build: () {
          when(mockSaveWatchlist.execute(testTvDetail))
              .thenAnswer((_) async =>  Right('Success'));
          when(mockGetWatchlistStatus.execute(testTvDetail.id))
              .thenAnswer((_) async => true);
          return bloc;
        },
        act: (bloc) {
          bloc.add( OnAddWatchlist(testTvDetail));
        },
        wait:  Duration(milliseconds: 500),
        expect: () => [
          tvDetailStateInit.copyWith(watchlistMessage: 'Success'),
          tvDetailStateInit.copyWith(
              isAddedToWatchlist: true, watchlistMessage: 'Success'),
        ],
        verify: (bloc) {
          mockSaveWatchlist.execute(testTvDetail);
        },
      );
      blocTest<TvDetailBloc, TvDetailState>(
        'Should emit failed to add into watchlist when failed',
        build: () {
          when(mockSaveWatchlist.execute(testTvDetail))
              .thenAnswer((_) async =>  Left(Failed('')));
          when(mockGetWatchlistStatus.execute(testTvDetail.id))
              .thenAnswer((_) async => false);
          return bloc;
        },
        act: (bloc) {
          bloc.add(OnAddWatchlist(testTvDetail));
        },
        wait: const Duration(milliseconds: 500),
        expect: () => [
          tvDetailStateInit.copyWith(
              isAddedToWatchlist: false, watchlistMessage: ''),
        ],
        verify: (bloc) {
          mockSaveWatchlist.execute(testTvDetail);
        },
      );
      blocTest<TvDetailBloc, TvDetailState>(
        'Should emit watchlistmessage and remove the watchlist when removed from watchlist',
        build: () {
          when(mockRemoveWatchlist.execute(tTvDetail))
              .thenAnswer((_) async => const Right('Success'));
          when(mockGetWatchlistStatus.execute(tTvDetail.id))
              .thenAnswer((_) async => false);
          return bloc;
        },
        act: (bloc) {
          bloc.add( OnRemoveWatchlist(tTvDetail));
        },
        wait: const Duration(milliseconds: 500),
        expect: () => [
          tvDetailStateInit.copyWith(
              isAddedToWatchlist: false, watchlistMessage: 'Success'),
        ],
        verify: (bloc) {
          mockRemoveWatchlist.execute(tTvDetail);
          mockGetWatchlistStatus.execute(tTvDetail.id);
        },
      );
      blocTest<TvDetailBloc, TvDetailState>(
        'Should emit failed when fail to remove watchlist',
        build: () {
          when(mockRemoveWatchlist.execute(tTvDetail))
              .thenAnswer((_) async => Left(Failed('')));
          when(mockGetWatchlistStatus.execute(tTvDetail.id))
              .thenAnswer((_) async => true);
          return bloc;
        },
        act: (bloc) {
          bloc.add( OnRemoveWatchlist(tTvDetail));
        },
        wait: const Duration(milliseconds: 500),
        expect: () => [
          tvDetailStateInit.copyWith(
              isAddedToWatchlist: false, watchlistMessage: ''),
              tvDetailStateInit.copyWith(
              isAddedToWatchlist: true, watchlistMessage: ''),
        ],
        verify: (bloc) {
          mockRemoveWatchlist.execute(tTvDetail);
          mockGetWatchlistStatus.execute(tTvDetail.id);
        },
      );
    },
  );
}

