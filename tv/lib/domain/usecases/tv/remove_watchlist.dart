import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

import '../../entities/tv/tv_detail.dart';
import '../../repositories/tv/tv_repository.dart';

class RemoveWatchlistTv {
  final TvRepository repository;

  RemoveWatchlistTv(this.repository);

  Future<Either<Failure, String>> execute(TvDetail tv) {
    return repository.removeWatchlistTv(tv);
  }
}
