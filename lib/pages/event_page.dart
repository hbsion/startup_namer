import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/pages/event_page_header.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/widgets/sticky/sticky_header_list.dart';

class EventPage extends StatelessWidget {
  final int eventId;

  const EventPage({Key key, @required this.eventId})
      : assert(eventId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<Event>(
      mapper: (store) => new Observable.empty(),
      snapshot: (store) => store.eventStore[eventId].last,
      widgetBuilder: _buildWidget,
    );
  }

  Scaffold _buildWidget(BuildContext context, Event model) {
    return new Scaffold(
      appBar: new AppBar(
        flexibleSpace: _resolveBanner(model),
        title: new Theme(
            data: ThemeData.dark(),
            child: new Center(child: new EventPageHeader(key: Key(eventId.toString()), eventId: eventId))),
      ),
      //appBar: new PreferredSize(child: Text("alala"), preferredSize: new Size(1920.0,56.0)),
      body: new StickyList(
        children: _buildRows(context).toList(),
      ),
    );
  }

  Image _resolveBanner(Event model) {
    if (model.sport == "FOOTBALL") {
      return new Image.asset('assets/football-banner.jpg', fit: BoxFit.cover);
    }
    if (model.sport == "ICE_HOCKEY") {
      return new Image.asset('assets/icehockey-banner.jpg',
          fit: BoxFit.cover, colorBlendMode: BlendMode.srcOver, color: new Color.fromARGB(120, 20, 10, 40));
    }

    return new Image.asset('assets/aqua.jpg', fit: BoxFit.cover);
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
