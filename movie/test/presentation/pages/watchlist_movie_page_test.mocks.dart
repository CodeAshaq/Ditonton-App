// Mocks generated by Mockito 5.1.0 from annotations
// in movie/test/presentation/pages/watchlist_movie_page_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:bloc/bloc.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;
import 'package:movie/presentation/bloc/watchlist/watchlist_movie_bloc.dart'
    as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeWatchlistMovieState_0 extends _i1.Fake
    implements _i2.WatchlistMovieState {}

/// A class which mocks [WatchlistMovieBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockWatchlistMovieBloc extends _i1.Mock
    implements _i2.WatchlistMovieBloc {
  MockWatchlistMovieBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.WatchlistMovieState get state => (super.noSuchMethod(
      Invocation.getter(#state),
      returnValue: _FakeWatchlistMovieState_0()) as _i2.WatchlistMovieState);
  @override
  _i3.Stream<_i2.WatchlistMovieState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i2.WatchlistMovieState>.empty())
          as _i3.Stream<_i2.WatchlistMovieState>);
  @override
  bool get isClosed =>
      (super.noSuchMethod(Invocation.getter(#isClosed), returnValue: false)
          as bool);
  @override
  _i4.EventTransformer<T> debounce<T>(Duration? duration) =>
      (super.noSuchMethod(Invocation.method(#debounce, [duration]),
          returnValue: (_i3.Stream<T> events, _i4.EventMapper<T> mapper) =>
              Stream<T>.empty()) as _i4.EventTransformer<T>);
  @override
  void add(_i2.WatchlistMovieEvent? event) =>
      super.noSuchMethod(Invocation.method(#add, [event]),
          returnValueForMissingStub: null);
  @override
  void onEvent(_i2.WatchlistMovieEvent? event) =>
      super.noSuchMethod(Invocation.method(#onEvent, [event]),
          returnValueForMissingStub: null);
  @override
  void emit(_i2.WatchlistMovieState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void on<E extends _i2.WatchlistMovieEvent>(
          _i4.EventHandler<E, _i2.WatchlistMovieState>? handler,
          {_i4.EventTransformer<E>? transformer}) =>
      super.noSuchMethod(
          Invocation.method(#on, [handler], {#transformer: transformer}),
          returnValueForMissingStub: null);
  @override
  void onTransition(
          _i4.Transition<_i2.WatchlistMovieEvent, _i2.WatchlistMovieState>?
              transition) =>
      super.noSuchMethod(Invocation.method(#onTransition, [transition]),
          returnValueForMissingStub: null);
  @override
  _i3.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
  @override
  void onChange(_i4.Change<_i2.WatchlistMovieState>? change) =>
      super.noSuchMethod(Invocation.method(#onChange, [change]),
          returnValueForMissingStub: null);
  @override
  void addError(Object? error, [StackTrace? stackTrace]) =>
      super.noSuchMethod(Invocation.method(#addError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  void onError(Object? error, StackTrace? stackTrace) =>
      super.noSuchMethod(Invocation.method(#onError, [error, stackTrace]),
          returnValueForMissingStub: null);
}
