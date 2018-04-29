import 'package:flutter/material.dart';
import 'package:startup_namer/app_drawer.dart';
import 'package:startup_namer/views/event_list_view.dart';
import 'package:startup_namer/widgets/app_toolbar.dart';


class SportPage extends StatefulWidget {
  final String sport;
  final String league;
  final String region;
  final String participant;

  SportPage({Key key, this.sport, this.region, this.league, this.participant = "all"})
      : assert(sport !=null), assert(region !=null), assert(league !=null), assert(participant !=null), super(key: key);

  @override
  _SportPageState createState() {
    return new _SportPageState();
  }
}

class _SportPageState extends State<SportPage> {

  final GlobalKey<ScaffoldState> _matchesKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _outrightsKey = new GlobalKey<ScaffoldState>();

  final PageController _pageController = new PageController(keepPage: true);
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: new AppDrawer(),
        body: new Builder(builder: (ctx) {
          return new PageView(
              controller: _pageController,
              onPageChanged: _handlePageChanged,
              children: <Widget>[
                new Scaffold(
                    key: _matchesKey,
                    body: new CustomScrollView(
                      key: new PageStorageKey("matches"),
                      slivers: <Widget>[
                        new AppToolbar(title: _buildTitle(), onNavPress: _openDrawer(ctx)),
                        new EventListView(
                            sport: widget.sport,
                            league: widget.league,
                            region: widget.region,
                            participant: widget.participant,
                            filter: "matches")
                      ],
                    )
                ),
                new Scaffold(
                    key: _outrightsKey,
                    body: new CustomScrollView(
                      key: new PageStorageKey("competitions"),
                      slivers: <Widget>[
                        new AppToolbar(title: _buildTitle(), onNavPress: _openDrawer(ctx)),
                        new EventListView(
                            sport: widget.sport,
                            league: widget.league,
                            region: widget.region,
                            participant: widget.participant,
                            filter: "competitions")
                      ],
                    )
                ),
              ]
          );
        }),
        bottomNavigationBar: new BottomNavigationBar(
          currentIndex: _index,
          onTap: _handleTabTap,
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
                icon: new Icon(Icons.all_inclusive),
                title: new Text("Matches")),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.home),
                title: new Text("Outrights")),
          ],
        )
    );
  }

  VoidCallback _openDrawer(BuildContext context) {
    return () => Scaffold.of(context).openDrawer();
  }

  void _handlePageChanged(int index) {
    setState(() => _index = index);
  }

  void _handleTabTap(int index) {
    setState(() => _index = index);

    _pageController.animateToPage(
        index,
        curve: new ElasticInCurve(),
        duration: new Duration(microseconds: 200)
    );
  }

  String _buildTitle() {
    return (widget.league != "all" ? widget.league : widget.sport);
  }
}