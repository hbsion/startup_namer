import 'package:flutter/material.dart';
import 'package:svan_play/app_drawer.dart';
import 'package:svan_play/data/event_group.dart';
import 'package:svan_play/views/event_list_view.dart';
import 'package:svan_play/widgets/PageIndicator.dart';
import 'package:svan_play/widgets/app_toolbar.dart';
import 'package:svan_play/widgets/betslip/bet_slip_fab.dart';

class SportPage extends StatefulWidget {
  final String sport;
  final String league;
  final String region;
  final String participant;
  final EventGroup eventGroup;
  final String title;

  SportPage({Key key, this.sport, this.region, this.league, this.participant = "all", this.eventGroup, this.title})
      : assert(sport != null),
        assert(region != null),
        assert(league != null),
        assert(participant != null),
        super(key: key);

  @override
  _SportPageState createState() {
    return new _SportPageState();
  }
}

class _SportPageState extends State<SportPage> {
  final GlobalKey<ScaffoldState> _matchesKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _outrightsKey = new GlobalKey<ScaffoldState>();

  PageController _pageController;
  List<Widget> _pages;

  @override
  void initState() {
     var index = widget.participant != "all" ? 1 : 0;
    _pageController = new PageController(keepPage: true, initialPage: index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _ensurePages(context);
    return new Scaffold(
      drawer: new AppDrawer(),
      body: new PageView.builder(
          controller: _pageController,
          itemCount: 2,
          itemBuilder: (context, index) => _pages[index]
           ),
      bottomNavigationBar: _buildBottomAppBar(context),
      floatingActionButton: new BetSlipFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _buildBottomAppBar(BuildContext context) {
    return new PageIndicator(
        titles: ["Matches", "Competitions"],
        controller: _pageController,
        onPageSelected: (index) {
          _pageController.animateToPage(index, curve: Curves.ease, duration: new Duration(milliseconds: 300));
        });
  }

  VoidCallback _openDrawer(BuildContext context) {
    return () => Scaffold.of(context).openDrawer();
  }

  String _buildTitle() {
    return widget.eventGroup?.name ?? widget.title ?? widget.sport;
  }

  void _ensurePages(BuildContext context) {
    if (_pages == null) {
      _pages = [
        new Scaffold(
            key: _matchesKey,
            body: new CustomScrollView(
              key: new PageStorageKey("matches"),
              slivers: <Widget>[
                new AppToolbar(title: _buildTitle(), onNavPress: _openDrawer(context), sport: widget.sport),
                new EventListView(
                    sport: widget.sport,
                    league: widget.league,
                    region: widget.region,
                    participant: widget.participant,
                    filter: "matches")
              ],
            )),
        new Scaffold(
            key: _outrightsKey,
            body: new CustomScrollView(
              key: new PageStorageKey("competitions"),
              slivers: <Widget>[
                new AppToolbar(
                  title: _buildTitle(),
                  onNavPress: _openDrawer(context),
                  sport: widget.sport,
                ),
                new EventListView(
                    sport: widget.sport,
                    league: widget.league,
                    region: widget.region,
                    participant: widget.participant,
                    filter: "competitions")
              ],
            ))
      ];
    }
  }
}
