import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/event_state.dart';
import 'package:startup_namer/data/shirt_colors.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/util/dates.dart';
import 'package:startup_namer/util/sports.dart';
import 'package:startup_namer/widgets/count_down_widget.dart';
import 'package:startup_namer/widgets/empty_widget.dart';
import 'package:startup_namer/widgets/live_score_widget.dart';
import 'package:startup_namer/widgets/match_clock_widget.dart';
import 'package:startup_namer/widgets/render/TeamColorsPainter.dart';

class EventPageHeader extends StatelessWidget {
  final int eventId;

  const EventPageHeader({Key key, this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<Event>(
      mapper: (store) => store.eventStore[eventId].observable,
      snapshot: (store) => store.eventStore[eventId].last,
      widgetBuilder: _buildWidget,
    );
  }

  Widget _buildWidget(BuildContext context, Event model) {
    if (model == null) {
      return new EmptyWidget();
    }

    if (model.state == EventState.STARTED) {
      return _buildLiveHeader(context, model);
    } else {
      return _buildPrematchHeader(context, model);
    }
  }

  Widget _buildLiveHeader(BuildContext context, Event model) {
    return Row(
      children: <Widget>[
        Expanded(child: new LiveScoreWidget(eventId: eventId)),
        _buildMatchClock(context, model)
      ],
    );
  }

  Widget _buildMatchClock(BuildContext context, Event model) {
    if (!showMatchClockForSport(model.sport)) {
      return new EmptyWidget();
    }
    return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: new MatchClockWidget(eventId: eventId, style: Theme.of(context).textTheme.subhead),
      );
  }

  Widget _buildPrematchHeader(BuildContext context, Event model) {
    return new Row(
      children: <Widget>[_buildTeamsColumn(model, context), _buildTimeColum(model, context)],
    );
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
              new Flexible(child: Text(model.homeName, softWrap: true, style: textStyle)),
            ],
          ),
          Padding(padding: EdgeInsets.all(2.0)),
          emptyIfTrue(
            condition: model.awayName == null,
            context: context,
            builder: (context) => new Row(
                  children: <Widget>[
                    _renderTeamColors(model.teamColors?.away, context),
                    Text(model.awayName, style: textStyle),
                  ],
                ),
          )
        ],
      ),
    );
  }

  Widget _buildTimeColum(Event model, BuildContext context) {
    if (model.start.isAfter(DateTime.now()) &&
        model.start.subtract(new Duration(minutes: 15)).isBefore(DateTime.now())) {
      return new Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Center(child: new CountDownWidget(time: model.start)),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(prettyDate(model.start), style: _bodyTextStyle(context)),
          Padding(padding: EdgeInsets.all(2.0)),
          Text(formatDate(model.start, [HH, ":", nn]), style: _bodyTextStyle(context)),
        ],
      );
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
