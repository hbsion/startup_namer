import 'package:flutter/material.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/event_tags.dart';
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
    var textTheme = Theme
        .of(context)
        .textTheme;
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(event.homeName, overflow: TextOverflow.ellipsis, style: textTheme.subhead),
          new Text(event.awayName ?? "", style: textTheme.subhead),
          new Padding(padding: EdgeInsets.all(2.0)),
          _buildGroupPath(textTheme, event),
        ]
    );
  }

  Row _buildGroupPath(TextTheme textTheme, Event event) {
    return new Row(children: _buildGroupPathElements(textTheme, event).toList());
  }

  Iterable<Widget> _buildGroupPathElements(TextTheme textTheme, Event event) sync* {
    if (event.tags.contains(EventTags.offeredLive)) {
      yield new Padding(
          padding: EdgeInsets.only(right: 2.0),
          child: new Text("Live",
              style: textTheme.caption.merge(new TextStyle(color: Colors.red, fontStyle: FontStyle.italic))
          )
      );
    }
    for (var i = 0; i < event.path.length; ++i) {
      var group = event.path[i];
      if (i > 0) {
        yield new Padding(
            padding: EdgeInsets.only(left: 2.0, right: 2.0), child: new Text("/", style: textTheme.caption));
      }
      yield new Text(group.name, style: textTheme.caption);
    }
  }
}
