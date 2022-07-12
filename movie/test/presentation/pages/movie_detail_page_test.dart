import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';

class MovieDetailEventFake extends Fake implements MovieDetailEvent {}

class MovieDetailStateFake extends Fake implements MovieDetailState {}

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;

  setUpAll(() {
    registerFallbackValue(MovieDetailEventFake());
    registerFallbackValue(MovieDetailStateFake());
  });

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockMovieDetailBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('TV detail should be display circular progress when application is loading',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state).thenReturn(MovieDetailState.initial()
        .copyWith(movieDetailState: RequestState.Loading));

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets(
      'Recommendation should display loading',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(MovieDetailState.initial().copyWith(
      movieDetailState: RequestState.Loaded,
      movieDetail: testMovieDetail,
      movieRecommendationState: RequestState.Loading,
      movieRecommendations: <Movie>[],
      isAddedToWatchlist: false,
    ));

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget( MovieDetailPage(id: 1)));

    expect(progressBarFinder, findsWidgets);
  });

  testWidgets(
      'Button on the watchlist should add icon when the data not added to watchlist page',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(MovieDetailState.initial().copyWith(
      movieDetailState: RequestState.Loaded,
      movieDetail: testMovieDetail,
      movieRecommendationState: RequestState.Loaded,
      movieRecommendations: [testMovie],
      isAddedToWatchlist: false,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget( MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Button on the watchlist should add icon when the data added to watchlist page',
      (WidgetTester tester) async {
    when(() => mockMovieDetailBloc.state)
        .thenReturn(MovieDetailState.initial().copyWith(
      movieDetailState: RequestState.Loaded,
      movieDetail: testMovieDetail,
      movieRecommendationState: RequestState.Loaded,
      movieRecommendations: [testMovie],
      isAddedToWatchlist: true,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget( MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Button on the watchlist shoild add message when the data add to watchlist',
      (WidgetTester tester) async {
    whenListen(
        mockMovieDetailBloc,
        Stream.fromIterable([
          MovieDetailState.initial().copyWith(
            movieDetailState: RequestState.Loaded,
            movieDetail: testMovieDetail,
            movieRecommendationState: RequestState.Loaded,
            movieRecommendations: [testMovie],
            isAddedToWatchlist: false,
          ),
          MovieDetailState.initial().copyWith(
            movieDetailState: RequestState.Loaded,
            movieDetail: testMovieDetail,
            movieRecommendationState: RequestState.Loaded,
            movieRecommendations: [testMovie],
            isAddedToWatchlist: false,
            watchlistMessage: 'Added to Watchlist',
          ),
        ]),
        initialState: MovieDetailState.initial());

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget( MovieDetailPage(id: 1)));
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
        mockMovieDetailBloc,
        Stream.fromIterable([
          MovieDetailState.initial().copyWith(
            movieDetailState: RequestState.Loaded, movieDetail: testMovieDetail,
            movieRecommendationState: RequestState.Loaded,
            movieRecommendations: [testMovie],
            isAddedToWatchlist: false,
          ),
          MovieDetailState.initial().copyWith(
            movieDetailState: RequestState.Loaded,
            movieDetail: testMovieDetail,
            movieRecommendationState: RequestState.Loaded,
            movieRecommendations: [testMovie],
            isAddedToWatchlist: false,
            watchlistMessage: 'Removed from Watchlist',
          ),
        ]),
        initialState: MovieDetailState.initial());

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget( MovieDetailPage(id: 1)));
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
        mockMovieDetailBloc,
        Stream.fromIterable([
          MovieDetailState.initial().copyWith(
            movieDetailState: RequestState.Loaded,
            movieDetail: testMovieDetail,
            movieRecommendationState: RequestState.Loaded,
            movieRecommendations: [testMovie],
            isAddedToWatchlist: false,
          ),
          MovieDetailState.initial().copyWith(
            movieDetailState: RequestState.Loaded,
            movieDetail: testMovieDetail,
            movieRecommendationState: RequestState.Loaded,
            movieRecommendations: [testMovie],
            isAddedToWatchlist: false,
            watchlistMessage: 'Failed',
          ),
          MovieDetailState.initial().copyWith(
            movieDetailState: RequestState.Loaded,
            movieDetail: testMovieDetail,
            movieRecommendationState: RequestState.Loaded,
            movieRecommendations: [testMovie],
            isAddedToWatchlist: false,
            watchlistMessage: 'Failed ',
          ),
        ]),
        initialState: MovieDetailState.initial());

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget( MovieDetailPage(id: 1)));
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
    when(() => mockMovieDetailBloc.state).thenReturn(MovieDetailState.initial()
        .copyWith(
            movieDetailState: RequestState.Error,
            message: 'Failed to connect '));

    final textErrorBarFinder = find.text('Failed to connect ');

    await tester.pumpWidget(_makeTestableWidget( MovieDetailPage(id: 1)));
    await tester.pump();

    expect(textErrorBarFinder, findsOneWidget);
  });
}
