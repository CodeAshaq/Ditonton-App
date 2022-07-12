import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../bloc/watchlist/bloc/watchlist_tv_bloc.dart';
import '../../widgets/tv_card_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class WatchlistTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist_tv_page';

  @override
  _WatchlistTvPageState createState() => _WatchlistTvPageState();
}

class _WatchlistTvPageState extends State<WatchlistTvPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        BlocProvider.of<WatchlistTvBloc>(context, listen: false)
            .add(OnFetchWatchlistTv()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    BlocProvider.of<WatchlistTvBloc>(context, listen: false)
            .add(OnFetchWatchlistTv());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:  BlocBuilder<WatchlistTvBloc, WatchlistTvState>(
          builder: (context, state) {
            if (state is WatchlistTvLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistTvHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return TvCard(tv);
                },
                itemCount: state.result.length,
              );
            } else if (state is WatchlistTvEmpty) {
              return const Center(
                child: Center(child: Text("There's no tv that youre add on watchlist", style: TextStyle(color: Colors.white),),),

              );
            }
            else 
             {
              return const Center(
                key: Key('error_message'),
                child: Text("Error"),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
