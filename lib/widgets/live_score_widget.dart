import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/app_theme.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/event_stats.dart';
import 'package:startup_namer/data/score.dart';
import 'package:startup_namer/data/shirt_colors.dart';
import 'package:startup_namer/store/app_store.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/util/observable_ex.dart';
import 'package:startup_namer/widgets/empty_widget.dart';
import 'package:startup_namer/widgets/render/TeamColorsPainter.dart';

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
        appStore.statisticsStore.eventStats(eventId).observable,
        appStore.statisticsStore.score(eventId).observable,
        (event, eventStats, score) => _ViewModel(event, eventStats, score));
  }

  Widget _buildWidget(BuildContext context, _ViewModel model) {
    if (model == null || model.event == null) {
      return new EmptyWidget();
    }

    var columns = (<Widget>[]
      ..add(_buildTeamsColumn(model.event, context))
      ..add(_buildServeColumn(model.eventStats, context))
      ..addAll(_buildSetColumns(model.eventStats, context))
      ..add(_buildScoreColumn(model, context)));

    return new Row(children: columns);
  }

  Widget _buildTeamsColumn(Event model, BuildContext context) {
    TextStyle textStyle = _bodyTextStyle(context);
    return new Expanded(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Row(
            children: <Widget>[
              _renderTeamColors(model.teamColors?.home, context),
              new Flexible(child: Text(model.homeName, overflow: TextOverflow.clip,style: textStyle)),
            ],
          ),
          Padding(padding: EdgeInsets.all(2.0)),
          emptyIfTrue(
            condition: model.awayName == null,
            context: context,
            builder: (context) => new Row(
                  children: <Widget>[
                    _renderTeamColors(model.teamColors?.away, context),
                    new Flexible(child: Text(model.awayName, overflow: TextOverflow.clip, style: textStyle)),
                  ],
                ),
          )
        ],
      ),
    );
  }

  Widget _buildScoreColumn(_ViewModel model, BuildContext context) {
    TextStyle textStyle = _bodyTextStyle(context);
    if (model.eventStats != null && model.eventStats.sets != null) {
      textStyle = textStyle.merge(TextStyle(color: AppTheme.of(context).pointsColor));
    }
    return new Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(model.score != null ? model.score.home : "-", style: textStyle),
          Padding(padding: EdgeInsets.all(2.0)),
          Text(model.score != null ? model.score.away : "-", style: textStyle)
        ],
      ),
    );
  }

  Widget _buildServeColumn(EventStats eventStats, BuildContext context) {
    if (eventStats == null || eventStats.sets == null) {
      return EmptyWidget();
    }

    return new Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildServeIf(eventStats.sets.homeServe, context),
          Padding(padding: EdgeInsets.all(2.0)),
          _buildServeIf(!eventStats.sets.homeServe, context),
        ],
      ),
    );
  }

  Widget _buildServeIf(bool serving, BuildContext context) {
    return new Container(
        height: 18.0,
        child: new Center(
            child: new Container(
          width: 8.0,
          height: 8.0,
          decoration: new BoxDecoration(
              color: serving ? AppTheme.of(context).serverColor : Colors.transparent, shape: BoxShape.circle),
        )));
  }

  Iterable<Widget> _buildSetColumns(EventStats stats, BuildContext context) sync* {
    TextStyle textStyle = _bodyTextStyle(context);

    if (stats != null && stats.sets != null) {
      var homeSets = stats.sets.home;
      var awaySets = stats.sets.away;

      for (int i = 0; i < homeSets.length; i++) {
        var home = homeSets[i];
        var away = awaySets[i];

        home = home == -1 ? 0 : home;
        away = away == -1 ? 0 : away;

        yield new Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
    return Theme.of(context).textTheme.subhead;
  }

  _renderTeamColors(ShirtColors colors, BuildContext context) {
    return emptyIfTrue(
        condition: colors == null,
        context: context,
        builder: (_) => new Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: new CustomPaint(painter: new TeamColorsPainter(colors), size: Size(12.0, 12.0)),
            ));
  }
}

class _ViewModel {
  final Event event;
  final EventStats eventStats;
  final Score score;

  _ViewModel(this.event, this.eventStats, this.score);
}
