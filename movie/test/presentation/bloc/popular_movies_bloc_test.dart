import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/core.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movies_bloc_test.mocks.dart';



@GenerateMocks([GetPopularMovies])
void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late PopularMoviesBloc bloc;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    bloc = PopularMoviesBloc(mockGetPopularMovies);
  });

    test('initial state should be empty', () {
  expect(bloc.state, PopularMoviesEmpty());
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

  final tMovieList = <Movie>[];

   group('Movie Popular BLoc Test', () {
    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'should emit [loading, hasData] when data is loaded successfully',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(PopularMoviesEvent()),
      wait: const Duration(milliseconds: 500),
      expect: () => [PopularMoviesLoading(), PopularMoviesHasData(tMovieList)],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      }
    );

    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'should emit [loading, error] when data is loaded unsuccessfully',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(PopularMoviesEvent()),
      wait: const Duration(milliseconds: 500),
      expect: () => [PopularMoviesLoading(), PopularMoviesError('Server Failure')],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      }
    );
  });
}
