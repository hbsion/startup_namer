import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/event_stats.dart';
import 'package:startup_namer/data/score.dart';
import 'package:startup_namer/data/shirt_colors.dart';
import 'package:startup_namer/store/app_store.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/util/observable_ex.dart';
import 'package:startup_namer/widgets/empty_widget.dart';

class LiveScoreWidget extends StatelessWidget {
  final int eventId;

  const LiveScoreWidget({Key key, @required this.eventId})
      : assert(eventId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<_ViewModel>(
      mapper: _mapStateToViewModel,
      widgetBuilder: _buildWidget,
    );
  }

  Observable<_ViewModel> _mapStateToViewModel(AppStore appStore) {
    return ObservableEx.combineLatestEager3(
        appStore.eventStore[eventId].observable,
        appStore.statisticsStore
            .eventStats(eventId)
            .observable,
        appStore.statisticsStore
            .score(eventId)
            .observable,
            (event, eventStats, score) => _ViewModel(event, eventStats, score)
    );
  }

  Widget _buildWidget(BuildContext context, _ViewModel model) {
    if (model == null || model.event == null) {
      return new EmptyWidget();
    }

    var columns = <Widget>[];
    columns.add(_buildTeamsColumn(model.event, context));
    columns.addAll(_buildSetColumns(model.eventStats, context));
    columns.add(_buildScoreColumn(model.score, context));

    return new Row(children: columns);
  }

  Widget _buildTeamsColumn(Event model, BuildContext context) {
    TextStyle textStyle = _bodyTextStyle(context);
    return new Expanded(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            children: <Widget>[
              _renderTeamColors(model.teamColors?.home, context),
              Text(model.homeName, style: textStyle),
            ],
          ),
          Padding(padding: EdgeInsets.all(2.0)),
          new Row(
            children: <Widget>[
              _renderTeamColors(model.teamColors?.home, context),
              Text(model.awayName, style: textStyle),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreColumn(Score score, BuildContext context) {
    TextStyle textStyle = _bodyTextStyle(context);
    return new Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Column(
        children: <Widget>[
          Text(score != null ? score.home : "-", style: textStyle),
          Padding(padding: EdgeInsets.all(2.0)),
          Text(score != null ? score.away : "-", style: textStyle)
        ],
      ),
    );
  }

  Iterable<Widget> _buildSetColumns(EventStats stats, BuildContext context) sync* {
    TextStyle textStyle = _bodyTextStyle(context);

    if (stats != null && stats.sets != null) {
      var homeSets = stats.sets.home;
      var awaySets = stats.sets.away;

      for (int i = 0; i < homeSets.length; i++) {
        var home = homeSets[i];
        var away = awaySets[i];

        yield new Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Column(
            children: <Widget>[
              Text(home.toString(), style: textStyle),
              Padding(padding: EdgeInsets.all(2.0)),
              Text(away.toString(), style: textStyle)
            ],
          ),
        );
      }
    }
  }

  TextStyle _bodyTextStyle(BuildContext context) {
    return Theme
        .of(context)
        .textTheme
        .subhead;
  }

  _renderTeamColors(ShirtColors home, BuildContext context) {
    return Text("X");
  }
}

class _ViewModel {
  final Event event;
  final EventStats eventStats;
  final Score score;

  _ViewModel(this.event, this.eventStats, this.score);
}
