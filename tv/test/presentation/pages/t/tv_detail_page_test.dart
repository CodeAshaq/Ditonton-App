import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/domain/entities/tv/tvseries.dart';
import 'package:tv/presentation/bloc/tv_detail/bloc/tv_detail_bloc.dart';
import 'package:tv/presentation/pages/tv/tv_detail_page.dart';

import '../../../dummy_data/tv/dummy_objects_tv.dart';

class TvDetailEventFake extends Fake implements TvDetailEvent {}

class TvDetailStateFake extends Fake implements TvDetailState {}

class MockTvDetailBloc extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

void main() {
  late MockTvDetailBloc mockTvDetailBloc;

  setUpAll(() {
    registerFallbackValue(TvDetailEventFake());
    registerFallbackValue(TvDetailStateFake());
  });

  setUp(() {
    mockTvDetailBloc = MockTvDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvDetailBloc>.value(
      value: mockTvDetailBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('TV detail should be display circular progress when application is loading',
      (WidgetTester tester) async {
    when(() => mockTvDetailBloc.state).thenReturn(TvDetailState.initial()
        .copyWith(tvDetailState: RequestState.Loading));

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets(
      'Recommendation should display loading',
      (WidgetTester tester) async {
    when(() => mockTvDetailBloc.state)
        .thenReturn(TvDetailState.initial().copyWith(
      tvDetailState: RequestState.Loaded,
      tvDetail: testTvDetail,
      tvRecommendationState: RequestState.Loading,
      tvRecommendations: <Tv>[],
      isAddedToWatchlist: false,
    ));

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget( TvDetailPage(id: 1)));

    expect(progressBarFinder, findsWidgets);
  });

  testWidgets(
      'Button on the watchlist should add icon when the data not added to watchlist page',
      (WidgetTester tester) async {
    when(() => mockTvDetailBloc.state)
        .thenReturn(TvDetailState.initial().copyWith(
      tvDetailState: RequestState.Loaded,
      tvDetail: testTvDetail,
      tvRecommendationState: RequestState.Loaded,
      tvRecommendations: [testTv],
      isAddedToWatchlist: false,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget( TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Button on the watchlist should add icon when the data added to watchlist page',
      (WidgetTester tester) async {
    when(() => mockTvDetailBloc.state)
        .thenReturn(TvDetailState.initial().copyWith(
      tvDetailState: RequestState.Loaded,
      tvDetail: testTvDetail,
      tvRecommendationState: RequestState.Loaded,
      tvRecommendations: [testTv],
      isAddedToWatchlist: true,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget( TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Button on the watchlist shoild add message when the data add to watchlist',
      (WidgetTester tester) async {
    whenListen(
        mockTvDetailBloc,
        Stream.fromIterable([
          TvDetailState.initial().copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvDetail,
            tvRecommendationState: RequestState.Loaded,
            tvRecommendations: [testTv],
            isAddedToWatchlist: false,
          ),
          TvDetailState.initial().copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvDetail,
            tvRecommendationState: RequestState.Loaded,
            tvRecommendations: [testTv],
            isAddedToWatchlist: false,
            watchlistMessage: 'Added to Watchlist',
          ),
        ]),
        initialState: TvDetailState.initial());

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget( TvDetailPage(id: 1)));
    await tester.pump();

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Button on the watchlist shoild add message when the data remove from watchlist',
      (WidgetTester tester) async {
    whenListen(
        mockTvDetailBloc,
        Stream.fromIterable([
          TvDetailState.initial().copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvDetail,
            tvRecommendationState: RequestState.Loaded,
            tvRecommendations: [testTv],
            isAddedToWatchlist: false,
          ),
          TvDetailState.initial().copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvDetail,
            tvRecommendationState: RequestState.Loaded,
            tvRecommendations: [testTv],
            isAddedToWatchlist: false,
            watchlistMessage: 'Removed from Watchlist',
          ),
        ]),
        initialState: TvDetailState.initial());

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget( TvDetailPage(id: 1)));
    await tester.pump();

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Removed from Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Button on the watchlist should add notification when error',
      (WidgetTester tester) async {
    whenListen(
        mockTvDetailBloc,
        Stream.fromIterable([
          TvDetailState.initial().copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvDetail,
            tvRecommendationState: RequestState.Loaded,
            tvRecommendations: [testTv],
            isAddedToWatchlist: false,
          ),
          TvDetailState.initial().copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvDetail,
            tvRecommendationState: RequestState.Loaded,
            tvRecommendations: [testTv],
            isAddedToWatchlist: false,
            watchlistMessage: 'Failed',
          ),
          TvDetailState.initial().copyWith(
            tvDetailState: RequestState.Loaded,
            tvDetail: testTvDetail,
            tvRecommendationState: RequestState.Loaded,
            tvRecommendations: [testTv],
            isAddedToWatchlist: false,
            watchlistMessage: 'Failed ',
          ),
        ]),
        initialState: TvDetailState.initial());

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget( TvDetailPage(id: 1)));
    await tester.pump();

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton, warnIfMissed: false);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets(
      'Tv Detail should add message error when data error',
      (WidgetTester tester) async {
    when(() => mockTvDetailBloc.state).thenReturn(TvDetailState.initial()
        .copyWith(
            tvDetailState: RequestState.Error,
            message: 'Failed to connect '));

    final textErrorBarFinder = find.text('Failed to connect ');

    await tester.pumpWidget(_makeTestableWidget( TvDetailPage(id: 1)));
    await tester.pump();

    expect(textErrorBarFinder, findsOneWidget);
  });
}
 
