import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/data/event_stats.dart';
import 'package:startup_namer/data/score.dart';
import 'package:startup_namer/store/app_store.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/widgets/empty_widget.dart';

class ScoreWidget extends StatelessWidget {
  final int eventId;
  final String sport;

  const ScoreWidget({Key key, this.eventId, this.sport})
      : assert(eventId != null),
        assert(sport != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<_ViewModel>(
        mapper: _mapStateToViewModel,
        widgetBuilder: _buildWidget
    );
  }

  Observable<_ViewModel> _mapStateToViewModel(AppStore store) {
    return Observable.combineLatest2(
        store.statisticsStore
            .score(eventId)
            .observable,
        store.statisticsStore
            .eventStats(eventId)
            .observable,
            (score, stats) => new _ViewModel(score, stats));
  }

  Widget _buildWidget(BuildContext context, _ViewModel model) {
    if (model == null || model.score == null) {
      return new EmptyWidget();
    }

    if (model.stats != null && model.stats.sets != null && model.score != null) {
      return _buildSetBased(context, model);
    } else {
      return _buildFootball(context, model);
    }
  }

  Widget _buildFootball(BuildContext context, _ViewModel model) {
    var textTheme = Theme
        .of(context)
        .textTheme;
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text(model.score.home, style: textTheme.subhead),
        new Text(model.score.away, style: textTheme.subhead),
      ],
    );
  }

  Widget _buildSetBased(BuildContext context, _ViewModel model) {
    return new EmptyWidget();
  }
}

class _ViewModel {
  final Score score;
  final EventStats stats;

  _ViewModel(this.score, this.stats);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is _ViewModel &&
              runtimeType == other.runtimeType &&
              score == other.score &&
              stats == other.stats;

  @override
  int get hashCode =>
      score.hashCode ^
      stats.hashCode;

  @override
  String toString() {
    return '_ViewModel{score: $score, stats: $stats}';
  }

}
