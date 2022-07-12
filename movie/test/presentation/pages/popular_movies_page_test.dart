import 'package:core/utils/state_enum.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
// import 'package:movie/presentation/provider/popular_movies_notifier.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movies_page_test.mocks.dart';


@GenerateMocks([PopularMoviesBloc])
void main() {
  late MockPopularMoviesBloc mockPopularMoviesBloc;

  setUp(() {
    mockPopularMoviesBloc = MockPopularMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesBloc>(
      create: (context) => mockPopularMoviesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading', (WidgetTester tester) async {
    // when(mockPopularMoviesBloc.state).thenReturn(PopularMoviesLoading());
    when(mockPopularMoviesBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMoviesLoading()));
    when(mockPopularMoviesBloc.state).thenReturn(PopularMoviesLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Home page should display circular progress indicator bar when loading',
      (WidgetTester tester) async {
    // when(mockPopularMoviesBloc.state).thenReturn(PopularMoviesLoading());
    when(mockPopularMoviesBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMoviesLoading()));
    when(mockPopularMoviesBloc.state).thenReturn(PopularMoviesLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget( PopularMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Home page should display circular progress indicator bar when loading',
      (WidgetTester tester) async {
    final movieList = <Movie>[];
    when(mockPopularMoviesBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMoviesHasData(movieList)));
    when(mockPopularMoviesBloc.state).thenReturn(PopularMoviesHasData(movieList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget( PopularMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Home page should add notification message when data Error',
      (WidgetTester tester) async {
    when(mockPopularMoviesBloc.stream)
        .thenAnswer((_) => Stream.value(const PopularMoviesError('Error message')));
    when(mockPopularMoviesBloc.state).thenReturn(const PopularMoviesError('Error message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget( PopularMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
