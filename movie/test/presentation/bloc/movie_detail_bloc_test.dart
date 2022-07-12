import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:movie/domain/entities/genre.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:core/core.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
// import 'package:movie/presentation/bloc/movie_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
    late int listenerCallCount;


  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
        listenerCallCount = 0;

    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    bloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  final tId = 1;
  final movieDetailStateInit = MovieDetailState.initial();
  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 1,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );


  group(
    'Get Movie Detail',
    () {
      blocTest<MovieDetailBloc, MovieDetailState>(
        'Should change movie when data is gotten succesfully',
        build: () {
          when(mockGetMovieDetail.execute(tId))
              .thenAnswer((_) async => Right(testMovieDetail));
          when(mockGetMovieRecommendations.execute(tId))
              .thenAnswer((_) async => Right(tMovies));
          return bloc;
        },
        act: (bloc) => bloc.add( OnFetchMovieDetail(tId)),
        wait:  Duration(milliseconds: 500),
        expect: () => [
          movieDetailStateInit.copyWith(movieDetailState: RequestState.Loading),
          movieDetailStateInit.copyWith(
            movieRecommendationState: RequestState.Loading,
            movieDetail: tMovieDetail,
            movieDetailState: RequestState.Loaded,
            message: '',
          ),
          movieDetailStateInit.copyWith(
            movieDetailState: RequestState.Loaded,
            movieDetail: tMovieDetail,
            movieRecommendationState: RequestState.Loaded,
            movieRecommendations: tMovies,
            message: '',
          ),
        ],
        verify: (bloc) {
          mockGetMovieDetail.execute(tId);
          mockGetMovieRecommendations.execute(tId);
        },
      );
      blocTest<MovieDetailBloc, MovieDetailState>(
        'Should return Error when data is failed',
        build: () {
          when(mockGetMovieDetail.execute(tId)).thenAnswer(
              (_) async =>  Left(ServerFailure('Server Failure')));
          when(mockGetMovieRecommendations.execute(tId)).thenAnswer(
              (_) async =>  Left(ServerFailure('Server Failure')));
          return bloc;
        },
        act: (bloc) => bloc.add( OnFetchMovieDetail(tId)),
        wait:  Duration(milliseconds: 500),
        expect: () => [
          movieDetailStateInit.copyWith(movieDetailState: RequestState.Loading),
          movieDetailStateInit.copyWith(
            movieRecommendationState: RequestState.Empty,
            movieDetailState: RequestState.Error,
          ),
        ],
        verify: (bloc) {
          mockGetMovieDetail.execute(tId);
        },
      );
    },
  );

  group(
    'Watchlist',
    () {
      blocTest<MovieDetailBloc, MovieDetailState>(
        'Should get the watchlist status',
        build: () {
          when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
          return bloc;
        },
        act: (bloc) => bloc.add( OnLoadWatchlistStatus(tId)),
        wait:  Duration(milliseconds: 500),
        expect: () => [
          movieDetailStateInit.copyWith(isAddedToWatchlist: true),
        ],
        verify: (bloc) {
          mockGetWatchlistStatus.execute(1);
        },
      );
      blocTest<MovieDetailBloc, MovieDetailState>(
        'Should emit watchlistmessage and add the watchlist when added to watchlist',
        build: () {
          when(mockSaveWatchlist.execute(testMovieDetail))
              .thenAnswer((_) async =>  Right('Success'));
          when(mockGetWatchlistStatus.execute(testMovieDetail.id))
              .thenAnswer((_) async => true);
          return bloc;
        },
        act: (bloc) {
          bloc.add( OnAddWatchlist(testMovieDetail));
        },
        wait:  Duration(milliseconds: 500),
        expect: () => [
          movieDetailStateInit.copyWith(watchlistMessage: 'Success'),
          movieDetailStateInit.copyWith(
              isAddedToWatchlist: true, watchlistMessage: 'Success'),
        ],
        verify: (bloc) {
          mockSaveWatchlist.execute(testMovieDetail);
        },
      );
      blocTest<MovieDetailBloc, MovieDetailState>(
        'Should emit failed to add into watchlist when failed',
        build: () {
          when(mockSaveWatchlist.execute(testMovieDetail))
              .thenAnswer((_) async =>  Left(Failed('')));
          when(mockGetWatchlistStatus.execute(testMovieDetail.id))
              .thenAnswer((_) async => false);
          return bloc;
        },
        act: (bloc) {
          bloc.add(OnAddWatchlist(testMovieDetail));
        },
        wait: const Duration(milliseconds: 500),
        expect: () => [
          movieDetailStateInit.copyWith(
              isAddedToWatchlist: false, watchlistMessage: ''),
        ],
        verify: (bloc) {
          mockSaveWatchlist.execute(testMovieDetail);
        },
      );
      blocTest<MovieDetailBloc, MovieDetailState>(
        'Should emit watchlistmessage and remove the watchlist when removed from watchlist',
        build: () {
          when(mockRemoveWatchlist.execute(tMovieDetail))
              .thenAnswer((_) async => const Right('Success'));
          when(mockGetWatchlistStatus.execute(tMovieDetail.id))
              .thenAnswer((_) async => false);
          return bloc;
        },
        act: (bloc) {
          bloc.add( OnRemoveWatchlist(tMovieDetail));
        },
        wait: const Duration(milliseconds: 500),
        expect: () => [
          movieDetailStateInit.copyWith(
              isAddedToWatchlist: false, watchlistMessage: 'Success'),
        ],
        verify: (bloc) {
          mockRemoveWatchlist.execute(tMovieDetail);
          mockGetWatchlistStatus.execute(tMovieDetail.id);
        },
      );
      blocTest<MovieDetailBloc, MovieDetailState>(
        'Should emit failed when fail to remove watchlist',
        build: () {
          when(mockRemoveWatchlist.execute(tMovieDetail))
              .thenAnswer((_) async => Left(Failed('')));
          when(mockGetWatchlistStatus.execute(tMovieDetail.id))
              .thenAnswer((_) async => true);
          return bloc;
        },
        act: (bloc) {
          bloc.add( OnRemoveWatchlist(tMovieDetail));
        },
        wait: const Duration(milliseconds: 500),
        expect: () => [
          movieDetailStateInit.copyWith(
              isAddedToWatchlist: false, watchlistMessage: ''),
              movieDetailStateInit.copyWith(
              isAddedToWatchlist: true, watchlistMessage: ''),
        ],
        verify: (bloc) {
          mockRemoveWatchlist.execute(tMovieDetail);
          mockGetWatchlistStatus.execute(tMovieDetail.id);
        },
      );
    },
  );
}
