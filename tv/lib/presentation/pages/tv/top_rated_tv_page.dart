import 'package:core/core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/top_rated/bloc/top_rated_tv_bloc.dart';
import '../../widgets/tv_card_list.dart';

class TopRatedTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/top_rated_tv';

  @override
  _TopRateTvPageState createState() => _TopRateTvPageState();
}

class _TopRateTvPageState extends State<TopRatedTvPage> {
  @override
  void initState() {
    super.initState();
 Future.microtask(() =>
              BlocProvider.of<TopRatedTvBloc>(context).add( TopRatedTvEvent())
);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
          builder: (context, state) {
            if (state is TopRatedTvLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedTvHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return TvCard(tv);
                },
                itemCount: state.result.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(' '),
              );
            }
          },
        ),
      ),
    );
  }
}
