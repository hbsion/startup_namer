import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/app_theme.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/event_tags.dart';
import 'package:startup_namer/pages/event_page_header.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/util/banners.dart';
import 'package:startup_namer/views/markets_view.dart';
import 'package:startup_namer/views/match_events_view.dart';
import 'package:startup_namer/views/prematch_stats_view.dart';
import 'package:startup_namer/widgets/sticky/sticky_header_list.dart';

class EventPage extends StatefulWidget {
  final int eventId;

  const EventPage({Key key, @required this.eventId})
      : assert(eventId != null),
        super(key: key);

  @override
  _EventPageState createState() => new _EventPageState();
}

class _EventPageState extends State<EventPage> {
  PageController _pageController = new PageController();
  int _index = 0;
  List<Widget> _pages;

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<Event>(
      mapper: (store) => new Observable.empty(),
      snapshot: (store) => store.eventStore[widget.eventId].last,
      widgetBuilder: _buildWidget,
    );
  }

  @override
  void initState() {
    //_pages = _buildPageViews(model)
    super.initState();
  }

  Scaffold _buildWidget(BuildContext context, Event model) {
    return new Scaffold(
      appBar: new AppBar(
        flexibleSpace: bannerFor(model.sport, fallbackAsset: "assets/aqua.jpg"),
        title: new Theme(
            data: ThemeData.dark(),
            child:
                new Center(child: new EventPageHeader(key: Key(widget.eventId.toString()), eventId: widget.eventId))),
      ),
      body: new PageView.builder(
        physics: new AlwaysScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: _handlePageChanged,
        itemCount: model.tags.contains(EventTags.prematchStats) ? 3 : 2,
        itemBuilder: (context, index) {
          if (_pages == null) _pages = _buildPageViews(model).toList();
          return _pages[index];
        },
      ),
      bottomNavigationBar: _buildBottomAppBar(context, model),
      floatingActionButton: FloatingActionButton(
        backgroundColor: brandColorDark,
        foregroundColor: Colors.white,
        onPressed: () {},
        child: Icon(Icons.event),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  BottomAppBar _buildBottomAppBar(BuildContext context, Event model) {
    return BottomAppBar(
      hasNotch: true,
      child: new Container(
          height: 44.0,
          margin: EdgeInsets.only(right: 40.0),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _buildTabs(context, model).toList())),
    );
  }

  Iterable<Widget> _buildTabs(BuildContext context, Event model) sync* {
    var selectedStyle = TextStyle(fontSize: 16.0, color: Theme.of(context).accentColor);
    Widget buildTab(String title, int index) {
      return Expanded(
          child: FlatButton(
        child: Text(title, style: _index == index ? selectedStyle : null),
        onPressed: () => _handleTabTap(index),
      ));
    }

    yield buildTab("Markets", 0);
    yield buildTab("Events", 1);
    if (model.tags.contains(EventTags.prematchStats)) {
      yield buildTab("Stats", 2);
    }
  }

  Iterable<Widget> _buildPageViews(Event model) sync* {
    yield new MarketsView();
    yield new MatchEventsView();
    if (model.tags.contains(EventTags.prematchStats)) {
      yield new PreMatchStatsView();
    }
  }

  Iterable<StickyListRow> _buildRows(BuildContext context) sync* {
    for (int section = 0; section < 10; section++) {
      yield new HeaderRow(child: new Text("Section-$section"));
      for (int row = 0; row < 10; row++) {
        yield new RegularRow(child: new Text("Row-$section-$row"));
      }
    }
  }

  void _handleTabTap(int index) {
    //setState(() => _index = index);
    _pageController.animateToPage(index, curve: Curves.ease, duration: new Duration(milliseconds: 300));
  }

  void _handlePageChanged(int index) {
    setState(() => _index = index);
  }
}
