import 'dart:async';
import 'package:sqflite/sqflite.dart';

import 'package:core/core.dart';
import '../../../models/models_tv/tv_table.dart';

class DatabaseHelperTv {
  static DatabaseHelperTv? _databaseHelperTv;
  DatabaseHelperTv._instance() {
    _databaseHelperTv = this;
  }

  factory DatabaseHelperTv() => _databaseHelperTv ?? DatabaseHelperTv._instance();

  static Database? _databaseTv;

  Future<Database?> get databaseTv async {
    if (_databaseTv == null) {
      _databaseTv = await _initDb();
    }
    return _databaseTv;
  }

  static const String _tblWatchlistTv = 'watchlisttvs';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditontontv.db';

    var db = await openDatabase(databasePath, version: 2, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblWatchlistTv (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
  }

  Future<int> insertWatchlistTv(TvTable tv) async {
    final db = await databaseTv;
    return await db!.insert(_tblWatchlistTv, tv.toJson());
  }

  Future<int> removeWatchlistTv(TvTable tv) async {
    final db = await databaseTv;
    return await db!.delete(
      _tblWatchlistTv,
      where: 'id = ?',
      whereArgs: [tv.id],
    );
  }

  Future<Map<String, dynamic>?> getTvById(int id) async {
    final db = await databaseTv;
    final results = await db!.query(
      _tblWatchlistTv,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistTv() async {
    final db = await databaseTv;
    final List<Map<String, dynamic>> results = await db!.query(_tblWatchlistTv);

    return results;
  }
}
