import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:startup_namer/widgets/sticky/sticky_header_list.dart';

class EventPage extends StatelessWidget {
  final int eventId;

  const EventPage({Key key, @required this.eventId})
      : assert(eventId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(),
      body: new Center(
        child: new StickyList(
          children: _buildRows(context).toList(),
        ),
      ),
    );
  }

  Iterable<StickyListRow> _buildRows(BuildContext context) sync* {
    for (int section = 0; section < 10; section++) {
      yield new HeaderRow(child: new Text("Section-$section"));
      for (int row = 0; row < 10; row++) {
        yield new RegularRow(child: new Text("Row-$section-$row"));
      }
    }
  }
}
