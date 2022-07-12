import 'package:core/utils/state_enum.dart';
import 'package:tv/domain/entities/tv/tvseries.dart';
import 'package:tv/presentation/bloc/top_rated/bloc/top_rated_tv_bloc.dart';
import 'package:tv/presentation/pages/tv/top_rated_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/tv/bloc_helper.mocks.dart';




void main() {
  late MockTopRatedTvBloc mockTopRatedTvBloc;

  setUp(() {
    mockTopRatedTvBloc = MockTopRatedTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvBloc>(
      create: (context) => mockTopRatedTvBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Home Page should display circular progress bar when loading',
      (WidgetTester tester) async {
    // when(mockTopRatedTvBloc.state).thenReturn(TopRatedTvLoading());
    when(mockTopRatedTvBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedTvLoading()));
    when(mockTopRatedTvBloc.state).thenReturn(TopRatedTvLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Home Page display circular progress bar when loading',
      (WidgetTester tester) async {
    // when(mockTopRatedTvBloc.state).thenReturn(TopRatedTvLoading());
    when(mockTopRatedTvBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedTvLoading()));
    when(mockTopRatedTvBloc.state).thenReturn(TopRatedTvLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget( TopRatedTvPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Home Page should display data when data is loaded',
      (WidgetTester tester) async {
    final tvList = <Tv>[];
    when(mockTopRatedTvBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedTvHasData(tvList)));
    when(mockTopRatedTvBloc.state).thenReturn(TopRatedTvHasData(tvList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget( TopRatedTvPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockTopRatedTvBloc.stream)
        .thenAnswer((_) => Stream.value( TopRatedTvError('Error message')));
    when(mockTopRatedTvBloc.state).thenReturn( TopRatedTvError('Error message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget( TopRatedTvPage()));

    expect(textFinder, findsOneWidget);
  });
}
