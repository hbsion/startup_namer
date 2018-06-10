import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:rxdart/src/observable.dart';
import 'package:svan_play/data/event.dart';
import 'package:svan_play/data/occurence.dart';
import 'package:svan_play/store/actions.dart';
import 'package:svan_play/store/app_store.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/util/observable_ex.dart';

class MatchEventFeedView extends StatelessWidget {
  final int eventId;

  const MatchEventFeedView({Key key, @required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<_ViewModel>(
      initalData: _mapStateToInitalData,
      stream: _mapStateToStream,
      pollAction: liveStats(eventId),
      widgetBuilder: _buildWidget,
    );
  }

  _ViewModel _mapStateToInitalData(AppStore appStore) {
    return _ViewModel(appStore.eventStore[eventId].latest, appStore.statisticsStore.occurences(eventId).latest);
  }

  Observable<_ViewModel> _mapStateToStream(AppStore appStore) {
    return ObservableEx.combineLatestEager2(appStore.eventStore[eventId].observable,
        appStore.statisticsStore.occurences(eventId).observable, (event, occurences) => _ViewModel(event, occurences));
  }

  Widget _buildWidget(BuildContext context, _ViewModel model) {
    return Container(
      child: Text("event feed: occurences: ${model?.occurences?.length ?? -1}"),
    );
  }
}

class _ViewModel {
  final Event event;
  final List<Occurence> occurences;

  _ViewModel(this.event, this.occurences);
}

