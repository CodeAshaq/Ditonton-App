import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/presentation/bloc/now_playing/now_playing_movies_bloc.dart';

import 'now_playing_movie_bloc_test.mocks.dart';


@GenerateMocks([
  GetNowPlayingMovies,
])
void main() {
  late NowPlayingMoviesBloc nowPlayingMoviesBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    nowPlayingMoviesBloc = NowPlayingMoviesBloc(mockGetNowPlayingMovies);
  });

   test('initial state should be empty', () {
  expect(nowPlayingMoviesBloc.state, NowPlayingMoviesEmpty());
  });

  final tMovieList = <Movie>[];


    blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
      'should emit  when data is loaded succesfully',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return nowPlayingMoviesBloc;
      },
      act: (bloc) => bloc.add(NowPlayingMoviesEvent()),
      wait: const Duration(milliseconds: 500),
      expect: () =>
          [NowPlayingMoviesLoading(), NowPlayingMoviesHasData(tMovieList)],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );

    blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
      'should emit  when data is loaded unsuccesfully',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return nowPlayingMoviesBloc;
      },
      act: (bloc) => bloc.add(NowPlayingMoviesEvent()),
      wait: const Duration(milliseconds: 500),
      expect: () => [NowPlayingMoviesLoading(), NowPlayingMoviesError('Server Failure')],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      }
    );
}
