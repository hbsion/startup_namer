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
    return new _SportPageState();
  }
}

class _SportPageState extends State<SportPage> {

  final List<Widget> _views = [];
  final PageController _pageController = new PageController();
  int _index = 0;
  
  @override
  void initState() {
    super.initState();
    _views.add(
        new SportView(key: new Key("matches"),
            sport: widget.sport,
            league: widget.league,
            region: widget.region,
            prefix: "Matches-")
    );
    _views.add(
        new SportView(key: new Key("competitions"),
            sport: widget.sport,
            league: widget.league,
            region: widget.region,
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
    return (widget.league ?? widget.sport);
  }


}