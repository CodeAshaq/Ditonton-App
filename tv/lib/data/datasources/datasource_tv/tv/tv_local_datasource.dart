import 'package:core/utils/exception.dart';
import '../../../models/models_tv/tv_table.dart';
import '../db/database_helper_tvseries.dart';

abstract class TvLocalDataSource {
  Future<String> insertWatchlistTv(TvTable tv);
  Future<String> removeWatchlistTv(TvTable tv);
  Future<TvTable?> getTvById(int id);
  Future<List<TvTable>> getWatchlistTv();
}

class TvLocalDataSourceImpl implements TvLocalDataSource {
  final DatabaseHelperTv databaseHelperTv;

  TvLocalDataSourceImpl({required this.databaseHelperTv});

  @override
  Future<String> insertWatchlistTv(TvTable tv) async {
    try {
      await databaseHelperTv.insertWatchlistTv(tv);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlistTv(TvTable tv) async {
    try {
      await databaseHelperTv.removeWatchlistTv(tv);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

   @override
  Future<TvTable?> getTvById(int id) async {
    final result = await databaseHelperTv.getTvById(id);
    if (result != null) {
      return TvTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TvTable>> getWatchlistTv() async {
    final result = await databaseHelperTv.getWatchlistTv();
    return result.map((data) => TvTable.fromMap(data)).toList();
  }
}
