import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv/tvseries.dart';
import 'package:tv/domain/usecases/tv/get_watchlist_tv.dart';
import 'package:tv/presentation/bloc/watchlist/bloc/watchlist_tv_bloc.dart';

import '../../helpers/tv/bloc_helper.mocks.dart';



void main() {
  late MockGetWatchlistTv mockGetWatchlistTv;
  late WatchlistTvBloc blocTv;

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTv();
    blocTv = WatchlistTvBloc(mockGetWatchlistTv);
  });

  test('initial state should be empty', () {
  expect(blocTv.state, WatchlistTvEmpty());
  });

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

  final tId = 1;
  final tTvSeries = <Tv>[tTv];
 


   group('Tv Popular Test', () {
    blocTest<WatchlistTvBloc, WatchlistTvState>(
  'Should emit [Loading, HasData] when data is gotten successfully',
  build: () {
    when(mockGetWatchlistTv.execute())
        .thenAnswer((_) async => Right(tTvSeries));
    return blocTv;
  },
  act: (bloc) => bloc.add(OnFetchWatchlistTv()),
  wait: const Duration(milliseconds: 500),
  expect: () => [
    WatchlistTvLoading(),
    WatchlistTvHasData(tTvSeries),
  ],
  verify: (bloc) {
    verify(mockGetWatchlistTv.execute());
  },
);
    

   blocTest<WatchlistTvBloc, WatchlistTvState>(
  'Should emit [Loading, Error] when get search is unsuccessful',
  build: () {
    when(mockGetWatchlistTv.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    return blocTv;
  },
  act: (bloc) => bloc.add(OnFetchWatchlistTv()),
  wait: const Duration(milliseconds: 500),
  expect: () => [
    WatchlistTvLoading(),
    WatchlistTvError('Server Failure'),
  ],
  verify: (bloc) {
    verify(mockGetWatchlistTv.execute());
  },
);

  });
}
