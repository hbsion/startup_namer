import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:svan_play/data/event.dart';
import 'package:svan_play/data/event_tags.dart';
import 'package:svan_play/pages/event_page_header.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/util/banners.dart';
import 'package:svan_play/views/markets_view.dart';
import 'package:svan_play/views/match_events_view.dart';
import 'package:svan_play/views/prematch_stats_view.dart';
import 'package:svan_play/widgets/PageIndicator.dart';
import 'package:svan_play/widgets/betslip/bet_slip_fab.dart';

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
  List<Widget> _pages;

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<Event>(
      stream: (store) => new Observable.empty(),
      initalData: (store) => store.eventStore[widget.eventId].last,
      widgetBuilder: _buildWidget,
    );
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
        //onPageChanged: _handlePageChanged,
        itemCount: model.tags.contains(EventTags.prematchStats) ? 3 : 2,
        itemBuilder: (context, index) {
          if (_pages == null) _pages = _buildPageViews(model).toList();
          return _pages[index];
        },
      ),
      bottomNavigationBar: _buildBottomAppBar(context, model),
      floatingActionButton: new BetSlipFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _buildBottomAppBar(BuildContext context, Event model) {
    List<String> titles = ["Markets", "Events"];
    if (model.tags.contains(EventTags.prematchStats)) {
      titles.add("Stats");
    }
    return new PageIndicator(
        titles: titles,
        controller: _pageController,
        onPageSelected: (index) {
          _pageController.animateToPage(index, curve: Curves.ease, duration: new Duration(milliseconds: 300));
        });
  }

  Iterable<Widget> _buildPageViews(Event model) sync* {
    yield new MarketsView(eventId: widget.eventId);
    yield new MatchEventsView();
    if (model.tags.contains(EventTags.prematchStats)) {
      yield new PreMatchStatsView();
    }
  }

}

