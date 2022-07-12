import 'package:movie/domain/entities/genre.dart';
import 'package:tv/data/models/models_tv/tv_table.dart';
import 'package:tv/domain/entities/tv/tv_detail.dart';
import 'package:tv/domain/entities/tv/tvseries.dart';

final testTv = Tv(
  backdropPath: '/suopoADq0k8YZr4dQXcU6pToj6s.jpg',
  genreIds: const [10765, 18, 10759, 9648],
  id: 1399,
  originalName: 'Game of Thrones',
  overview:
      "Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north. Amidst the war, a neglected military order of misfits, the Night's Watch, is all that stands between the realms of men and icy horrors beyond.",
  popularity: 369.594,
  posterPath: '/u3bZgnGQ9T01sWNhyveQz0wH0Hl.jpg',
  firstAirDate: '2011-04-17',
  name: 'Game of Thrones',
  voteAverage: 8.3,
  voteCount: 11504
);

final testTvList = [testTv];

final testTvDetail = TvDetail(
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalName: 'originalName',
  overview: 'overview',
  posterPath: 'posterPath',
  firstAirDate: 'firstAirDate',
  name: 'name',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistTv = Tv.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvTable = TvTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};
