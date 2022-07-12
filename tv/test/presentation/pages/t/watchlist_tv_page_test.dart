import 'package:core/utils/state_enum.dart';
import 'package:tv/domain/entities/tv/tvseries.dart';
import 'package:tv/presentation/bloc/top_rated/bloc/top_rated_tv_bloc.dart';
import 'package:tv/presentation/bloc/watchlist/bloc/watchlist_tv_bloc.dart';
import 'package:tv/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/pages/tv/watchlist_tv_page.dart';

import '../../../helpers/tv/bloc_helper.mocks.dart';




void main() {
  late MockWatchlistTvBloc mockWatchlistTvBloc;

  setUp(() {
    mockWatchlistTvBloc = MockWatchlistTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTvBloc>(
      create: (context) => mockWatchlistTvBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display circular progress bar when loading',
      (WidgetTester tester) async {
    // when(mockWatchlistTvBloc.state).thenReturn(WatchlistTvLoading());
    when(mockWatchlistTvBloc.stream)
        .thenAnswer((_) => Stream.value(WatchlistTvLoading()));
    when(mockWatchlistTvBloc.state).thenReturn(WatchlistTvLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(WatchlistTvPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display circular progress bar when loading',
      (WidgetTester tester) async {
    // when(mockWatchlistTvBloc.state).thenReturn(WatchlistTvLoading());
    when(mockWatchlistTvBloc.stream)
        .thenAnswer((_) => Stream.value(WatchlistTvLoading()));
    when(mockWatchlistTvBloc.state).thenReturn(WatchlistTvLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget( WatchlistTvPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });



  testWidgets('Page should display Data when data is loaded',
      (WidgetTester tester) async {
    final tvList = <Tv>[];
    when(mockWatchlistTvBloc.stream)
        .thenAnswer((_) => Stream.value(WatchlistTvHasData(tvList)));
    when(mockWatchlistTvBloc.state).thenReturn(WatchlistTvHasData(tvList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget( WatchlistTvPage()));

    expect(listViewFinder, findsOneWidget);
  });



  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockWatchlistTvBloc.stream)
        .thenAnswer((_) => Stream.value( WatchlistTvError('Error message')));
    when(mockWatchlistTvBloc.state).thenReturn( WatchlistTvError('Error message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget( WatchlistTvPage()));

    expect(textFinder, findsOneWidget);
  });
}
