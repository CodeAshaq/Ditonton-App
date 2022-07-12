import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

import '../../entities/tv/tvseries.dart';
import '../../repositories/tv/tv_repository.dart';

class GetNowPlayingTv {
  final TvRepository repository;

  GetNowPlayingTv(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getNowPlayingTv();
  }
}
