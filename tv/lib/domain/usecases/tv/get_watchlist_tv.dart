import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

import '../../entities/tv/tvseries.dart';
import '../../repositories/tv/tv_repository.dart';

class GetWatchlistTv {
  final TvRepository _repository;

  GetWatchlistTv(this._repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return _repository.getWatchlistTv();
  }
}
