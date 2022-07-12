import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

import '../../entities/tv/tvseries.dart';
import '../../repositories/tv/tv_repository.dart';

class GetTvRecommendations {
  final TvRepository repository;

  GetTvRecommendations(this.repository);

  Future<Either<Failure, List<Tv>>> execute(id) {
    return repository.getTvRecommendations(id);
  }
}
