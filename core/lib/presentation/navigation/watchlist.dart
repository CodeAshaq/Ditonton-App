import 'package:flutter/material.dart';
import 'package:movie/presentation/pages/watchlist_movies_page.dart';
import 'package:tv/presentation/pages/tv/watchlist_tv_page.dart';


class WatchList extends StatelessWidget {
  const WatchList({ Key? key }) : super(key: key);
  static const ROUTE_NAME = '/watchlist';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist Ditonton', textAlign: TextAlign.center,),
      ),
      body: Padding(padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movie'),
              onTap: (){
                Navigator.pushNamed(context, WatchlistMoviesPage.ROUTE_NAME);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv_rounded),
              title: Text('TV Series'),
              onTap: (){
                Navigator.pushNamed(context, WatchlistTvPage.ROUTE_NAME);
              },
            )
          ],
        ),
      ),
      
      ),
    );
  }
}