import 'package:core/utils/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/data/datasources/datasource_tv/tv/tv_local_datasource.dart';

import '../../../dummy_data/tv/dummy_objects_tv.dart';
import '../../../helpers/tv/test_helper_tv.mocks.dart';
void main() {
  late TvLocalDataSourceImpl dataSourceTv;
  late MockDatabaseHelperTv mockDatabaseHelperTv;

  setUp(() {
    mockDatabaseHelperTv = MockDatabaseHelperTv();
    dataSourceTv = TvLocalDataSourceImpl(databaseHelperTv: mockDatabaseHelperTv);
  });

  group('save watchlist TV Series', () {
    test('should return success message when insert to tv database is success',
        () async {
      // arrange
      when(mockDatabaseHelperTv.insertWatchlistTv(testTvTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSourceTv.insertWatchlistTv(testTvTable);
      // assert
      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert to TV Series database is failed',
        () async {
      // arrange
      when(mockDatabaseHelperTv.insertWatchlistTv(testTvTable))
          .thenThrow(Exception());
      // act
      final call = dataSourceTv.insertWatchlistTv(testTvTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist TV Series', () {
    test('should return success message when remove from database is success',
        () async {
      // arrange
      when(mockDatabaseHelperTv.removeWatchlistTv(testTvTable))
          .thenAnswer((_) async => 1);
      // act
      final result = await dataSourceTv.removeWatchlistTv(testTvTable);
      // assert
      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove from database is failed',
        () async {
      // arrange
      when(mockDatabaseHelperTv.removeWatchlistTv(testTvTable))
          .thenThrow(Exception());
      // act
      final call = dataSourceTv.removeWatchlistTv(testTvTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get TV Series Detail By Id', () {
    final tId = 1;

    test('should return Tv Detail Table when data is found', () async {
      // arrange
      when(mockDatabaseHelperTv.getTvById(tId))
          .thenAnswer((_) async => testTvMap);
      // act
      final result = await dataSourceTv.getTvById(tId);
      // assert
      expect(result, testTvTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelperTv.getTvById(tId)).thenAnswer((_) async => null);
      // act
      final result = await dataSourceTv.getTvById(tId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist TV Series', () {
    test('should return list of Tv Table from database', () async {
      // arrange
      when(mockDatabaseHelperTv.getWatchlistTv())
          .thenAnswer((_) async => [testTvMap]);
      // act
      final result = await dataSourceTv.getWatchlistTv();
      // assert
      expect(result, [testTvTable]);
    });
  });
}
