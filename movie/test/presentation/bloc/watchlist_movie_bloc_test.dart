import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';
import 'package:movie/presentation/bloc/watchlist/watchlist_movie_bloc.dart';

import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistMovies,
])
void main() {
  late WatchlistMovieBloc watchlistMovieBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMovieBloc = WatchlistMovieBloc(mockGetWatchlistMovies);
  });

  test('initial state should be empty', () {
  expect(watchlistMovieBloc.state, WatchlistMovieEmpty());
  });

  final tMovieWatchlist = Movie.watchlist(
    id: 1,
    overview: 'overview',
    posterPath: 'posterPath',
    title: 'title',
  );

   blocTest<WatchlistMovieBloc, WatchlistMovieState>(
  'Should emit [Loading, HasData] when data is gotten successfully',
  build: () {
    when(mockGetWatchlistMovies.execute())
        .thenAnswer((_) async => Right([tMovieWatchlist]));
    return watchlistMovieBloc;
  },
  act: (bloc) => bloc.add(OnFetchWatchlistMovie()),
  wait: const Duration(milliseconds: 500),
  expect: () => [
    WatchlistMovieLoading(),
    WatchlistMovieHasData([tMovieWatchlist]),
  ],
  verify: (bloc) {
    verify(mockGetWatchlistMovies.execute());
  },
);
 
blocTest<WatchlistMovieBloc, WatchlistMovieState>(
  'Should emit [Loading, Error] when get search is unsuccessful',
  build: () {
    when(mockGetWatchlistMovies.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    return watchlistMovieBloc;
  },
  act: (bloc) => bloc.add(OnFetchWatchlistMovie()),
  wait: const Duration(milliseconds: 500),
  expect: () => [
    WatchlistMovieLoading(),
    WatchlistMovieError('Server Failure'),
  ],
  verify: (bloc) {
    verify(mockGetWatchlistMovies.execute());
  },
);
}
