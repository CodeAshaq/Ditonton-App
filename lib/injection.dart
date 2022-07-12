import 'package:core/ssl/ssl_pining.dart';
import 'package:movie/data/datasources/db/database_helper_movie.dart';
import 'package:movie/data/datasources/movie_local_data_source.dart';
import 'package:movie/data/datasources/movie_remote_data_source.dart';
import 'package:movie/data/repositories/movie_repository_impl.dart';
import 'package:movie/domain/repositories/movie_repository.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/now_playing/now_playing_movies_bloc.dart';
import 'package:movie/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:movie/presentation/bloc/top_rated/top_rated_movies_bloc.dart';
import 'package:movie/presentation/bloc/watchlist/watchlist_movie_bloc.dart';
import 'package:search/domain/usecases/search_movies.dart';
import 'package:search/presentation/pages/bloc/search_movie_bloc.dart';
import 'package:search/presentation/pages/bloc/search_tv_bloc.dart';
import 'package:tv/domain/usecases/tv/get_now_playing_tv.dart';
import 'package:tv/domain/usecases/tv/get_popular_tv.dart';
import 'package:tv/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:tv/domain/usecases/tv/remove_watchlist.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

import 'package:tv/data/datasources/datasource_tv/db/database_helper_tvseries.dart';
import 'package:tv/data/datasources/datasource_tv/tv/tv_local_datasource.dart';
import 'package:tv/data/datasources/datasource_tv/tv/tv_remote_datasource.dart';
import 'package:tv/data/repositories/tv/tv_repository_impl.dart';
import 'package:tv/domain/repositories/tv/tv_repository.dart';
import 'package:tv/domain/usecases/tv/get_tv_detail.dart';
import 'package:tv/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/tv/get_watchlist_status_tv.dart';
import 'package:tv/domain/usecases/tv/get_watchlist_tv.dart';
import 'package:tv/domain/usecases/tv/save_watchlist.dart';
import 'package:search/domain/usecases/tv/search_tv.dart';
import 'package:tv/presentation/bloc/now_playing/bloc/now_playing_tv_bloc.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:tv/presentation/bloc/top_rated/bloc/top_rated_tv_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail/bloc/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/watchlist/bloc/watchlist_tv_bloc.dart';

final locator = GetIt.instance;

void init() {

  //MOVIES
   locator.registerFactory(
    () => NowPlayingMoviesBloc(
      locator(),
    ),
  );

   locator.registerFactory(
    () => PopularMoviesBloc(
      locator(),
    ),
  );

   locator.registerFactory(
    () => TopRatedMoviesBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => MovieDetailBloc(
    getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      removeWatchlist: locator(),
      saveWatchlist: locator(),
    ),
  );
  
  locator.registerFactory(
    () => SearchMovieBloc(
      locator(),
    ),
  );
  
  locator.registerFactory(
    () => WatchlistMovieBloc(locator(),
    ),
  );
  
  

  //TV
   locator.registerFactory(
    () => NowPlayingTvBloc(
      locator(),
    ),
  );

   locator.registerFactory(
    () => PopularTvBloc(
      locator(),
    ),
  );

   locator.registerFactory(
    () => TopRatedTvBloc(
      locator(),
    ),
  );
  
  locator.registerFactory(
    () => TvDetailBloc(
      getTvDetail: locator(),
      getTvRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );

  locator.registerFactory(
    () => SearchTvBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => WatchlistTvBloc( locator(),
    ),
  );

  // use case 
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetNowPlayingTv(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetPopularTv(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedTv(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => SearchTv(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTv(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTv(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTv(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetWatchlistTv(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvRemoteDataSource>(
      () => TvRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvLocalDataSource>(
      () => TvLocalDataSourceImpl(databaseHelperTv: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  locator.registerLazySingleton<DatabaseHelperTv>(() => DatabaseHelperTv());

  // external
  locator.registerLazySingleton(() => http.Client());

  //SSL
  locator.registerLazySingleton<ApiIOClient>(() => ApiIOClient());
}
