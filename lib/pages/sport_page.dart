import 'package:flutter/material.dart';
import 'package:startup_namer/app_drawer.dart';
import 'package:startup_namer/views/SportsView.dart';
import 'package:startup_namer/widgets/app_toolbar.dart';


class SportPage extends StatefulWidget {
  final String sport;
  final String league;
  final String region;

  SportPage({Key key, this.sport, this.league, this.region}) : super(key: key);

  @override
  _SportPageState createState() {
    return new _SportPageState(sport, league, region);
  }
}

class _SportPageState extends State<SportPage> {
  final String sport;
  final String league;
  final String region;
  final List<Widget> _views = [];
  final ScrollController _scrollController = new ScrollController();
  final PageController _pageController = new PageController();
  int _index = 0;

  _SportPageState(this.sport, this.league, this.region) {
    _views.add(
        new SportView(key: new Key("matches"),
            sport: sport,
            league: league,
            region: region,
            prefix: "Matches-")
    );
    _views.add(
        new SportView(key: new Key("competitions"),
            sport: sport,
            league: league,
            region: region,
            prefix: "Competitions-")
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: new AppDrawer(),
        body: new Builder(builder: (ctx) {
          return new PageView(
              controller: _pageController,
              onPageChanged: _handlePageChanged,
              children: <Widget>[
                _buildPageView(0, _openDrawer(ctx)),
                _buildPageView(1, _openDrawer(ctx)),
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
                title: new Text("Competitions")),
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

    _pageController.animateToPage(index,
        curve: new ElasticInCurve(0.01),
        duration: new Duration(microseconds: 200));
  }

  Widget _buildPageView(int index, VoidCallback openDrawer) {
    return new Scaffold(
        body: new CustomScrollView(
          slivers: <Widget>[
            new AppToolbar(title: _buildTitle(index), onNavPress: openDrawer),
            _views[index]
          ],
        )
    );
  }

  String _buildTitle(int index) {
    return (league ?? sport);
  }


}