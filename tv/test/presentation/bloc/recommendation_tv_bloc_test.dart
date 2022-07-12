import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/core.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv/tvseries.dart';
import 'package:tv/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:tv/presentation/bloc/recommendations/bloc/recommendation_tv_bloc.dart';

import '../../helpers/tv/bloc_helper.mocks.dart';




void main() {
  late MockGetTvRecommendations mockGetTvRecommendations;
  late RecommendationTvBloc blocTv;

  setUp(() {
    mockGetTvRecommendations = MockGetTvRecommendations();
    blocTv = RecommendationTvBloc(mockGetTvRecommendations);
  });

    test('initial state should be empty', () {
  expect(blocTv.state, RecommendationTvEmpty());
  });
  
  final tId = 1;

  final tTv = Tv(
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    firstAirDate: "firsAirDate",
    posterPath: 'posterPath',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvSeries = <Tv>[tTv];

   group('Tv Recommendation BLoc Test', () {
    blocTest<RecommendationTvBloc, RecommendationTvState>(
      'should emit [loading, hasData] when data is loaded successfully',
      build: () {
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tTvSeries));
        return blocTv;
      },
      act: (bloc) => bloc.add(OnFetchRecommendationTv(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [RecommendationTvLoading(), RecommendationTvHasData(tTvSeries)],
      verify: (bloc) {
        verify(mockGetTvRecommendations.execute(tId));
      }
    );

    blocTest<RecommendationTvBloc, RecommendationTvState>(
      'should emit [loading, error] when data is loaded unsuccessfully',
      build: () {
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return blocTv;
      },
      act: (bloc) => bloc.add(OnFetchRecommendationTv(tId)),
      wait: const Duration(milliseconds: 500),
      expect: () => [RecommendationTvLoading(), RecommendationTvError('Server Failure')],
      verify: (bloc) {
        verify(mockGetTvRecommendations.execute(tId));
      }
    );
  });
}
