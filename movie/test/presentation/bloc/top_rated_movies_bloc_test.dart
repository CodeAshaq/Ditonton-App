import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/bloc/top_rated/top_rated_movies_bloc.dart';
import 'package:bloc_test/bloc_test.dart';


import 'top_rated_movies_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late TopRatedMoviesBloc blocMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    blocMovies = TopRatedMoviesBloc(mockGetTopRatedMovies);
  });

    test('initial state should be empty', () {
  expect(blocMovies.state, TopRatedMoviesEmpty());
  });

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
   final tId = 1;
  final tMovieList = <Movie>[tMovie];
 

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
  'Should emit [Loading, HasData] when data is gotten successfully',
  build: () {
    when(mockGetTopRatedMovies.execute())
        .thenAnswer((_) async => Right(tMovieList));
    return blocMovies;
  },
  act: (bloc) => bloc.add(OnFetchTopRatedMovies(tId)),
  wait: const Duration(milliseconds: 500),
  expect: () => [
    TopRatedMoviesLoading(),
    TopRatedMoviesHasData(tMovieList),
  ],
  verify: (bloc) {
    verify(mockGetTopRatedMovies.execute());
  },
);

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
  'Should emit [Loading, Error] when get search is unsuccessful',
  build: () {
    when(mockGetTopRatedMovies.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    return blocMovies;
  },
  act: (bloc) => bloc.add(OnFetchTopRatedMovies(tId)),
  wait: const Duration(milliseconds: 500),
  expect: () => [
    TopRatedMoviesLoading(),
    TopRatedMoviesError('Server Failure'),
  ],
  verify: (bloc) {
    verify(mockGetTopRatedMovies.execute());
  },
);

}
