import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/bloc/recommendation/recommendation_movie_bloc.dart';

import 'movie_detail_bloc_test.mocks.dart';


@GenerateMocks([GetMovieRecommendations])
void main() {
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late RecommendationMovieBloc blocMovie;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    blocMovie = RecommendationMovieBloc(mockGetMovieRecommendations);
  });

  test('initial state should be empty', () {
  expect(blocMovie.state, RecommendationMovieEmpty());
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: '/backdropPath.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: '/posterPath.jpg',
    releaseDate: '2002-05-01',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tId = 1;
  final tMovies = <Movie>[tMovie];
 


   group('Movie Popular Test', () {
    blocTest<RecommendationMovieBloc, RecommendationMovieState>(
  'Should emit [Loading, HasData] when data is gotten successfully',
  build: () {
    when(mockGetMovieRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tMovies));
    return blocMovie;
  },
  act: (bloc) => bloc.add(OnFetchRecommendationMovie(tId)),
  wait: const Duration(milliseconds: 500),
  expect: () => [
    RecommendationMovieLoading(),
    RecommendationMovieHasData(tMovies),
  ],
  verify: (bloc) {
    verify(mockGetMovieRecommendations.execute(tId));
  },
);
    

   blocTest<RecommendationMovieBloc, RecommendationMovieState>(
  'Should emit [Loading, Error] when get search is unsuccessful',
  build: () {
    when(mockGetMovieRecommendations.execute(tId))
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    return blocMovie;
  },
  act: (bloc) => bloc.add(OnFetchRecommendationMovie(tId)),
  wait: const Duration(milliseconds: 500),
  expect: () => [
    RecommendationMovieLoading(),
    RecommendationMovieError('Server Failure'),
  ],
  verify: (bloc) {
    verify(mockGetMovieRecommendations.execute(tId));
  },
);

  });
}
