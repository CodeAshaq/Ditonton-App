import 'package:mockito/annotations.dart';
import 'package:tv/domain/usecases/tv/get_now_playing_tv.dart';
import 'package:tv/domain/usecases/tv/get_popular_tv.dart';
import 'package:tv/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:tv/domain/usecases/tv/get_tv_detail.dart';
import 'package:tv/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/tv/get_watchlist_status_tv.dart';
import 'package:tv/domain/usecases/tv/get_watchlist_tv.dart';
import 'package:tv/domain/usecases/tv/remove_watchlist.dart';
import 'package:tv/domain/usecases/tv/save_watchlist.dart';
import 'package:tv/presentation/bloc/popular_tv/popular_tv_bloc.dart';
import 'package:tv/presentation/bloc/top_rated/bloc/top_rated_tv_bloc.dart';
import 'package:tv/presentation/bloc/watchlist/bloc/watchlist_tv_bloc.dart';

@GenerateMocks([
  GetNowPlayingTv,
  GetPopularTv,
  GetTvRecommendations,
  GetTopRatedTv,
  GetWatchlistTv,
  GetTvDetail,
  GetWatchListStatusTv,
  SaveWatchlistTv,
  RemoveWatchlistTv,
  PopularTvBloc,
  TopRatedTvBloc,
  WatchlistTvBloc

])
void main() {}
