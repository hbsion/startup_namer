import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/data/event_stats.dart';
import 'package:startup_namer/data/score.dart';
import 'package:startup_namer/store/app_store.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/widgets/empty_widget.dart';

class ScoreWidget extends StatelessWidget {
  static final Color serverColor = Color.fromRGBO(0xf7, 0xce, 0x00, 1.0);
  static final Color scoreColor = Color.fromRGBO(0x00, 0xad, 0xc9, 1.0);
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
    var textTheme = Theme
        .of(context)
        .textTheme;
    var status = calculateGameSummary(model.stats, sport == "TENNIS");
    var scoreTextStyle = textTheme.subhead.merge(new TextStyle(color: scoreColor));
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Container(
            margin: EdgeInsets.only(right: 4.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text(status.homeSets.toString(), style: textTheme.subhead),
                new Text(status.awaySets.toString(), style: textTheme.subhead),
              ],
            )
        ),
        sport == "TENNIS"
            ? new Container(
            margin: EdgeInsets.only(right: 4.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text(status.homeGames.toString(), style: textTheme.subhead),
                new Text(status.awayGames.toString(), style: textTheme.subhead),
              ],
            )
        ) : new EmptyWidget(),
        new Container(
            margin: EdgeInsets.only(right: 4.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text(model.score.home, style: scoreTextStyle),
                new Text(model.score.away, style: scoreTextStyle),
              ],
            )
        ),
        new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildServeIf(model.stats.sets.homeServe),
            _buildServeIf(!model.stats.sets.homeServe),
          ],
        )
        ,
      ],
    );
  }

  Widget _buildServeIf(bool serving) {
    return new Container(
        height: 18.0,
        child: new Center(
            child: new Container(
              width: 8.0,
              height: 8.0,
              decoration: new BoxDecoration(
                  color: serving ? serverColor : Colors.transparent,
                  shape: BoxShape.circle
              ),)
        )
    );
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

class _GameStatus {
  int homeSets = 0;
  int homeGames = 0;
  int awaySets = 0;
  int awayGames = 0;
}

_GameStatus calculateGameSummary(EventStats stats, bool hasGames) {
  var status = new _GameStatus();

  if (stats != null && stats.sets != null) {
    var sets = stats.sets;
    var numberOfSets = sets.home.length;
    var firstUnplayedSetIndex = sets.home.indexOf(-1);
    var currentSet = (firstUnplayedSetIndex == -1) ? numberOfSets - 1 : firstUnplayedSetIndex;

    // in tennis, the current set is the last one with a score, not the first one without
    if (hasGames && sets.home[currentSet] == -1 && sets.away[currentSet] == -1) {
      currentSet -= 1;
    }

    // if the score in the previous set is level, that set has not yet ended. it is likely a tie-break
    if (currentSet > 0 && sets.home[currentSet - 1] == sets.away[currentSet - 1]) {
      currentSet -= 1;
    } else if (hasGames &&
        currentSet > 0 &&
        (sets.home[currentSet] + sets.away[currentSet] == 0) &&
        (sets.home[currentSet - 1] - sets.away[currentSet - 1]).abs() == 1 &&
        max(sets.home[currentSet - 1], sets.away[currentSet - 1]) == 6) {
      // DUE to NLS BUG
      currentSet -= 1;
    }

    for (var i = currentSet; i >= 0; i--) {
      var home = sets.home[i];
      var away = sets.away[i];

      if (hasGames && i == currentSet) {
        status.homeGames = home;
        status.awayGames = away;
      } else {
        if (home > away) status.homeSets++;
        if (home < away) status.awaySets++;
      }
    }
  }

  return status;
}