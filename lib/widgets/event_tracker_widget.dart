import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:svan_play/data/event.dart';
import 'package:svan_play/data/event_state.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/util/dates.dart';
import 'package:svan_play/util/sports.dart';
import 'package:svan_play/widgets/count_down_widget.dart';
import 'package:svan_play/widgets/empty_widget.dart';
import 'package:svan_play/widgets/event_score_widget.dart';
import 'package:svan_play/widgets/match_clock_widget.dart';

class EventTrackingWidget extends StatelessWidget {
  final int eventId;

  const EventTrackingWidget({Key key, @required this.eventId})
      : assert(eventId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<Event>(
        stream: (store) => store.eventStore[eventId].observable,
        initalData: (store) => store.eventStore[eventId].last,
        widgetBuilder: _buildWidget);
  }

  Widget _buildWidget(BuildContext context, Event model) {
    Widget w;
    if (model.state == EventState.STARTED) {
      w = new Column(children: <Widget>[
        new ScoreWidget(eventId: eventId, sport: model.sport),
        new Padding(padding: EdgeInsets.all(2.0)),
        showMatchClockForSport(model.sport) ? new MatchClockWidget(eventId: eventId) : new EmptyWidget()
      ]);
    } else if (model.start.isAfter(DateTime.now()) &&
        model.start.subtract(new Duration(minutes: 15)).isBefore(DateTime.now())) {
      w = new CountDownWidget(time: model.start);
    } else {
      w = new _DateTimeWidget(event: model);
    }

    return Center(child: w);
  }
}

class _DateTimeWidget extends StatelessWidget {
  final Event event;

  const _DateTimeWidget({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isToday(event.start)) {
      return new Text(formatDate(event.start, [HH, ":", nn]));
    } else if (event.start.isBefore(DateTime.now().add(new Duration(days: 7)))) {
      // less than a week
      return new Column(children: <Widget>[
        new Text(formatDate(event.start, [D]), style: new TextStyle(fontWeight: FontWeight.w700)),
        new Text(formatDate(event.start, [HH, ":", nn]))
      ]);
    }
    return new Column(children: <Widget>[
      new Text(formatDate(event.start, [d, " ", M]), style: new TextStyle(fontWeight: FontWeight.w700)),
      new Text(formatDate(event.start, [HH, ":", nn]))
    ]);
  }
}
