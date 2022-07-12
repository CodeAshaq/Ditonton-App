import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/entities/tv/tvseries.dart';
import 'package:tv/domain/usecases/tv/get_now_playing_tv.dart';
import 'package:tv/presentation/bloc/now_playing/bloc/now_playing_tv_bloc.dart';

import '../../helpers/tv/bloc_helper.mocks.dart';



void main() {
  late NowPlayingTvBloc nowPlayingTvBloc;
  late MockGetNowPlayingTv mockGetNowPlayingTv;

  setUp(() {
    mockGetNowPlayingTv = MockGetNowPlayingTv();
    nowPlayingTvBloc = NowPlayingTvBloc(mockGetNowPlayingTv);
  });

   test('initial state should be empty', () {
  expect(nowPlayingTvBloc.state, NowPlayingTvEmpty());
  });

  final tMovieList = <Tv>[];


    blocTest<NowPlayingTvBloc, NowPlayingTvState>(
      'should emit  when data is loaded succesfully',
      build: () {
        when(mockGetNowPlayingTv.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return nowPlayingTvBloc;
      },
      act: (bloc) => bloc.add(NowPlayingTvEvent()),
      wait: const Duration(milliseconds: 500),
      expect: () =>
          [NowPlayingTvLoading(), NowPlayingTvHasData(tMovieList)],
      verify: (bloc) {
        verify(mockGetNowPlayingTv.execute());
      },
    );

    blocTest<NowPlayingTvBloc, NowPlayingTvState>(
      'should emit  when data is loaded unsuccesfully',
      build: () {
        when(mockGetNowPlayingTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return nowPlayingTvBloc;
      },
      act: (bloc) => bloc.add(NowPlayingTvEvent()),
      wait: const Duration(milliseconds: 500),
      expect: () => [NowPlayingTvLoading(), NowPlayingTvError('Server Failure')],
      verify: (bloc) {
        verify(mockGetNowPlayingTv.execute());
      }
    );
}
