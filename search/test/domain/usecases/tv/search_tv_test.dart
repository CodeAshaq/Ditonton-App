import 'package:dartz/dartz.dart';
import 'package:tv/domain/entities/tv/tvseries.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/tv/search_tv.dart';

import '../../../../../tv/test/helpers/tv/test_helper_tv.mocks.dart';


void main() {
  late SearchTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SearchTv(mockTvRepository);
  });

  final tTv = <Tv>[];
  final tQuery = 'game of thrones';

  test('should get list of TV Series from the repository', () async {
    // arrange
    when(mockTvRepository.searchTv(tQuery))
        .thenAnswer((_) async => Right(tTv));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tTv));
  });
}
