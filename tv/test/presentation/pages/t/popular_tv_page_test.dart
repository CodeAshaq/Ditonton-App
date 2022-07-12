import 'package:core/core.dart';
import 'package:tv/domain/entities/tv/tvseries.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:tv/presentation/pages/tv/popular_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../helpers/tv/bloc_helper.mocks.dart';





void main() {
  late MockPopularTvBloc mockPopularTvBloc;

  setUp(() {
    mockPopularTvBloc = MockPopularTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvBloc>(
      create: (context) => mockPopularTvBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    // when(mockPopularTvBloc.state).thenReturn(PopularTvLoading());
    when(mockPopularTvBloc.stream)
        .thenAnswer((_) => Stream.value(PopularTvLoading()));
    when(mockPopularTvBloc.state).thenReturn(PopularTvLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularTvPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Home page should display circular progress indicator bar when loading',
      (WidgetTester tester) async {
    // when(mockPopularTvBloc.state).thenReturn(PopularTvLoading());
    when(mockPopularTvBloc.stream)
        .thenAnswer((_) => Stream.value(PopularTvLoading()));
    when(mockPopularTvBloc.state).thenReturn(PopularTvLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget( PopularTvPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Home page should display circular progress indicator bar when loading',
      (WidgetTester tester) async {
    final tvList = <Tv>[];
    when(mockPopularTvBloc.stream)
        .thenAnswer((_) => Stream.value(PopularTvHasData(tvList)));
    when(mockPopularTvBloc.state).thenReturn(PopularTvHasData(tvList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget( PopularTvPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Home page should add notification message when data Error',
      (WidgetTester tester) async {
    when(mockPopularTvBloc.stream)
        .thenAnswer((_) => Stream.value( PopularTvError('Error message')));
    when(mockPopularTvBloc.state).thenReturn( PopularTvError('Error message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget( PopularTvPage()));

    expect(textFinder, findsOneWidget);
  });
}
