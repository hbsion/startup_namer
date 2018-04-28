import 'package:flutter/material.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/store/store_connector.dart';

class EventInfoWidget extends StatelessWidget {
  final int eventId;

  const EventInfoWidget({Key key, this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<Event>(
           mapper: (store) => store.eventStore[eventId].observable,
           snapshot: (store) => store.eventStore[eventId].last,
           widgetBuilder: _buildWidget
       );
  }

  Widget _buildWidget(BuildContext context, Event event) {
    return new Column(children: <Widget>[new Text(event.homeName), new Text(event.awayName ?? ""), new Text("path")]);

  }
}
