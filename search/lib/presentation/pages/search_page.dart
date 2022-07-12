import 'package:core/core.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/presentation/pages/bloc/search_movie_bloc.dart';


class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
  onChanged: (query) {
    context.read<SearchMovieBloc>().add(OnQueryMovieChanged(query));
  },
  decoration: InputDecoration(
    hintText: 'Search title',
    prefixIcon: Icon(Icons.search),
    border: OutlineInputBorder(),
  ),
  textInputAction: TextInputAction.search,
),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<SearchMovieBloc, SearchMovieState>(
  builder: (context, state) {
    if (state is SearchMovieLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is SearchMovieHasData) {
      final result = state.result;
      return Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemBuilder: (context, index) {
            final movie = result[index];
            return MovieCard(movie);
          },
          itemCount: result.length,
        ),
      );
    } else if (state is SearchMovieError) {
      return Expanded(
        child: Center(
          child: Text(state.message),
        ),
      );
    } else {
      return Expanded(
        child: Container(),
      );
    }
  },
),
          ],
        ),
      ),
    );
  }
}



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Search'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               onSubmitted: (query) {
//                 Provider.of<MovieSearchNotifier>(context, listen: false)
//                     .fetchMovieSearch(query);
//               },
//               decoration: InputDecoration(
//                 hintText: 'Search title',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(),
//               ),
//               textInputAction: TextInputAction.search,
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Search Result',
//               style: kHeading6,
//             ),
//             Consumer<MovieSearchNotifier>(
//               builder: (context, data, child) {
//                 if (data.state == RequestState.Loading) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (data.state == RequestState.Loaded) {
//                   final result = data.searchResult;
//                   return Expanded(
//                     child: ListView.builder(
//                       padding: const EdgeInsets.all(8),
//                       itemBuilder: (context, index) {
//                         final movie = data.searchResult[index];
//                         return MovieCard(movie);
//                       },
//                       itemCount: result.length,
//                     ),
//                   );
//                 } else {
//                   return Expanded(
//                     child: Container(),
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
