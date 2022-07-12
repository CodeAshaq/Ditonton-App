import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/bloc/top_rated/top_rated_movies_bloc.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_movies_page_test.mocks.dart';


@GenerateMocks([TopRatedMoviesBloc])
void main() {
  late MockTopRatedMoviesBloc mockTopRatedMoviesBloc;

  setUp(() {
    mockTopRatedMoviesBloc = MockTopRatedMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesBloc>(
      create: (context) => mockTopRatedMoviesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Home Page should display circular progress bar when loading',
      (WidgetTester tester) async {
    // when(mockTopRatedMoviesBloc.state).thenReturn(TopRatedMoviesLoading());
    when(mockTopRatedMoviesBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMoviesLoading()));
    when(mockTopRatedMoviesBloc.state).thenReturn(TopRatedMoviesLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Home Page display circular progress bar when loading',
      (WidgetTester tester) async {
    // when(mockTopRatedMoviesBloc.state).thenReturn(TopRatedMoviesLoading());
    when(mockTopRatedMoviesBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMoviesLoading()));
    when(mockTopRatedMoviesBloc.state).thenReturn(TopRatedMoviesLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget( TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Home Page should display data when data is loaded',
      (WidgetTester tester) async {
    final movieList = <Movie>[];
    when(mockTopRatedMoviesBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMoviesHasData(movieList)));
    when(mockTopRatedMoviesBloc.state).thenReturn(TopRatedMoviesHasData(movieList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget( TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockTopRatedMoviesBloc.stream)
        .thenAnswer((_) => Stream.value( TopRatedMoviesError('Error message')));
    when(mockTopRatedMoviesBloc.state).thenReturn( TopRatedMoviesError('Error message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget( TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
