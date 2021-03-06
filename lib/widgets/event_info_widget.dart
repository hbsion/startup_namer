import 'package:flutter/material.dart';
import 'package:svan_play/data/event.dart';
import 'package:svan_play/data/event_tags.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/widgets/empty_widget.dart';

class EventInfoWidget extends StatelessWidget {
  final int eventId;

  const EventInfoWidget({Key key, this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<Event>(
        stream: (store) => store.eventStore[eventId].observable,
        initalData: (store) => store.eventStore[eventId].latest,
        widgetBuilder: _buildWidget);
  }

  Widget _buildWidget(BuildContext context, Event event) {
    var textTheme = Theme.of(context).textTheme;
    return new Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      new Text(event.homeName, softWrap: false, overflow: TextOverflow.ellipsis, style: textTheme.subhead),
      event.awayName != null
          ? new Text(event.awayName, softWrap: false, overflow: TextOverflow.ellipsis, style: textTheme.subhead)
          : new EmptyWidget(),
      new Padding(padding: EdgeInsets.all(2.0)),
      _buildGroupPath(textTheme, event),
    ]);
  }

  Widget _buildGroupPath(TextTheme textTheme, Event event) {
    return new Container(child: new Row(children: _buildGroupPathElements(textTheme, event).toList()));
  }

  Iterable<Widget> _buildGroupPathElements(TextTheme textTheme, Event event) sync* {
    if (event.tags.contains(EventTags.offeredLive)) {
      yield new Padding(
          padding: EdgeInsets.only(right: 2.0),
          child: new Text("Live",
              style: textTheme.caption.merge(new TextStyle(color: Colors.red, fontStyle: FontStyle.italic))));
    }
    for (var i = 0; i < event.path.length; ++i) {
      var group = event.path[i];
      if (i > 0) {
        yield new Padding(
            padding: EdgeInsets.only(left: 2.0, right: 2.0), child: new Text("/", style: textTheme.caption));
      }
      yield new Flexible(child: new Text(group.name, softWrap: false, style: textTheme.caption));
    }
  }
}
