import 'package:core/ssl/ssl_pining.dart';
import 'package:tv/data/datasources/datasource_tv/db/database_helper_tvseries.dart';
import 'package:tv/data/datasources/datasource_tv/tv/tv_local_datasource.dart';
import 'package:tv/data/datasources/datasource_tv/tv/tv_remote_datasource.dart';
import 'package:tv/domain/repositories/tv/tv_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  TvRepository,
  TvRemoteDataSource,
  TvLocalDataSource,
  DatabaseHelperTv,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient),
  MockSpec<ApiIOClient>(as: #MockApiIOClient)
])
void main() {}
