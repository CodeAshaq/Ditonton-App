import 'package:core/core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/popular_tv/popular_tv_bloc.dart';
import '../../widgets/tv_card_list.dart';

class PopularTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular_tv';

  @override
  _PopularTvPageState createState() => _PopularTvPageState();
}

class _PopularTvPageState extends State<PopularTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
        BlocProvider.of<PopularTvBloc>(context).add(PopularTvEvent());
  });}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvBloc, PopularTvState>(
          builder: (context, state) {
            if (state is PopularTvLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is PopularTvHasData) {
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
