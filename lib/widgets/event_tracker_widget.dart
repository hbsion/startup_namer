import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/event_state.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/util/dates.dart';
import 'package:startup_namer/widgets/count_down.dart';

class EventTrackingWidget extends StatelessWidget {
  final int eventId;

  const EventTrackingWidget({Key key, @required this.eventId})
      : assert(eventId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<Event>(
        mapper: (store) => store.eventStore[eventId].observable,
        snapshot: (store) => store.eventStore[eventId].last,
        widgetBuilder: _buildWidget
    );
  }

  Widget _buildWidget(BuildContext context, Event model) {
    Widget w;
    if (model.state == EventState.STARTED) {
      w = new _MatchClockWidget(eventId: eventId);
    } else if (model.start.isAfter(DateTime.now()) &&
        model.start.subtract(new Duration(minutes: 15)).isBefore(DateTime.now())) {
      w = new CountDownWidget(time: model.start);
    } else {
      w = new _DateTimeWidget(event: model);
    }

    return Center(child: w);
  }
}

class _MatchClockWidget extends StatelessWidget {
  final int eventId;

  const _MatchClockWidget({Key key, @required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Text("Score");
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
      new Text(formatDate(event.start, [d, " ", MM]), style: new TextStyle(fontWeight: FontWeight.w700)),
      new Text(formatDate(event.start, [HH, ":", nn]))
    ]);
  }
}