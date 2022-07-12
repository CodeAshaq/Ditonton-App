
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/bloc/watchlist/watchlist_movie_bloc.dart';
import 'package:movie/presentation/pages/watchlist_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watchlist_movie_page_test.mocks.dart';




@GenerateMocks([WatchlistMovieBloc])
void main() {
  late MockWatchlistMovieBloc mockWatchlistMovieBloc;

  setUp(() {
    mockWatchlistMovieBloc = MockWatchlistMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistMovieBloc>(
      create: (context) => mockWatchlistMovieBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display circular progress bar when loading',
      (WidgetTester tester) async {
    // when(mockWatchlistMovieBloc.state).thenReturn(WatchlistMovieLoading());
    when(mockWatchlistMovieBloc.stream)
        .thenAnswer((_) => Stream.value(WatchlistMovieLoading()));
    when(mockWatchlistMovieBloc.state).thenReturn(WatchlistMovieLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display circular progress bar when loading',
      (WidgetTester tester) async {
    // when(mockWatchlistTvBloc.state).thenReturn(WatchlistTvLoading());
    when(mockWatchlistMovieBloc.stream)
        .thenAnswer((_) => Stream.value(WatchlistMovieLoading()));
    when(mockWatchlistMovieBloc.state).thenReturn(WatchlistMovieLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget( WatchlistMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });



  testWidgets('Page should display Data when data is loaded',
      (WidgetTester tester) async {
    final movieList = <Movie>[];
    when(mockWatchlistMovieBloc.stream)
        .thenAnswer((_) => Stream.value(WatchlistMovieHasData(movieList)));
    when(mockWatchlistMovieBloc.state).thenReturn(WatchlistMovieHasData(movieList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget( WatchlistMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });



  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(mockWatchlistMovieBloc.stream)
        .thenAnswer((_) => Stream.value( WatchlistMovieError('Error message')));
    when(mockWatchlistMovieBloc.state).thenReturn( WatchlistMovieError('Error message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget( WatchlistMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
