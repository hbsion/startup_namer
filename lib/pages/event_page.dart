import 'package:flutter/material.dart';
import 'package:meta/meta.dart';


class EventPage extends StatelessWidget {
  final int eventId;

  const EventPage({Key key, @required this.eventId})
      :
        assert(eventId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(),
      body: new Center(
        child: new Text("Event Page"),
      ),
    );
  }

}