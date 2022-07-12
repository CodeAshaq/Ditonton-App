import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/core.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv/tvseries.dart';
import 'package:tv/domain/usecases/tv/get_popular_tv.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_bloc.dart';

import '../../helpers/tv/bloc_helper.mocks.dart';



void main() {
  late MockGetPopularTv mockGetPopularTv;
  late PopularTvBloc bloc;

  setUp(() {
    mockGetPopularTv = MockGetPopularTv();
    bloc = PopularTvBloc(mockGetPopularTv);
  });

    test('initial state should be empty', () {
  expect(bloc.state, PopularTvEmpty());
  });
  

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

  final tTvList = <Tv>[];

   group('Tv Popular BLoc Test', () {
    blocTest<PopularTvBloc, PopularTvState>(
      'should emit [loading, hasData] when data is loaded successfully',
      build: () {
        when(mockGetPopularTv.execute())
            .thenAnswer((_) async => Right(tTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(PopularTvEvent()),
      wait: const Duration(milliseconds: 500),
      expect: () => [PopularTvLoading(), PopularTvHasData(tTvList)],
      verify: (bloc) {
        verify(mockGetPopularTv.execute());
      }
    );

    blocTest<PopularTvBloc, PopularTvState>(
      'should emit [loading, error] when data is loaded unsuccessfully',
      build: () {
        when(mockGetPopularTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(PopularTvEvent()),
      wait: const Duration(milliseconds: 500),
      expect: () => [PopularTvLoading(), PopularTvError('Server Failure')],
      verify: (bloc) {
        verify(mockGetPopularTv.execute());
      }
    );
  });
}
