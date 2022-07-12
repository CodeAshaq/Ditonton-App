import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/core.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv/tvseries.dart';
import 'package:tv/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:tv/presentation/bloc/top_rated/bloc/top_rated_tv_bloc.dart';

import '../../helpers/tv/bloc_helper.mocks.dart';




void main() {
  late MockGetTopRatedTv mockGetTopRatedTv;
  late TopRatedTvBloc blocTv;

  setUp(() {
    mockGetTopRatedTv = MockGetTopRatedTv();
    blocTv = TopRatedTvBloc(mockGetTopRatedTv);
  });

    test('initial state should be empty', () {
  expect(blocTv.state, TopRatedTvEmpty());
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

   group('Tv TopRated BLoc Test', () {
    blocTest<TopRatedTvBloc, TopRatedTvState>(
      'should emit [loading, hasData] when data is loaded successfully',
      build: () {
        when(mockGetTopRatedTv.execute())
            .thenAnswer((_) async => Right(tTvList));
        return blocTv;
      },
      act: (bloc) => bloc.add(TopRatedTvEvent()),
      wait: const Duration(milliseconds: 500),
      expect: () => [TopRatedTvLoading(), TopRatedTvHasData(tTvList)],
      verify: (bloc) {
        verify(mockGetTopRatedTv.execute());
      }
    );

    blocTest<TopRatedTvBloc, TopRatedTvState>(
      'should emit [loading, error] when data is loaded unsuccessfully',
      build: () {
        when(mockGetTopRatedTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return blocTv;
      },
      act: (bloc) => bloc.add(TopRatedTvEvent()),
      wait: const Duration(milliseconds: 500),
      expect: () => [TopRatedTvLoading(), TopRatedTvError('Server Failure')],
      verify: (bloc) {
        verify(mockGetTopRatedTv.execute());
      }
    );
  });
}
