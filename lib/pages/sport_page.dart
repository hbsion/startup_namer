import 'package:flutter/material.dart';
import 'package:startup_namer/app_drawer.dart';
import 'package:startup_namer/data/event_group.dart';
import 'package:startup_namer/views/event_list_view.dart';
import 'package:startup_namer/widgets/app_toolbar.dart';

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
  int _index = 0;

  @override
  void initState() {
    _index = widget.participant != "all" ? 1 : 0;
    _pageController = new PageController(keepPage: true, initialPage: _index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: new AppDrawer(),
      body: new Builder(builder: (ctx) {
        return new PageView(controller: _pageController, onPageChanged: _handlePageChanged, children: <Widget>[
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
              )),
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
              )),
        ]);
      }),
      bottomNavigationBar: _buildBottomAppBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.event),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  BottomAppBar _buildBottomAppBar(BuildContext context) {
    var selectedStyle = TextStyle(fontSize: 16.0, color: Theme.of(context).accentColor);
    return BottomAppBar(
      hasNotch: true,
      child: new Container(
          height: 44.0,
          margin: EdgeInsets.only(right: 40.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  child: Text("Matches", style: _index == 0 ? selectedStyle : null),
                  onPressed: () => _handleTabTap(0),
                ),
              ),
              Expanded(
                child: FlatButton(
                  child: Text("Competitions", style: _index == 1 ? selectedStyle : null),
                  onPressed: () => _handleTabTap(1),
                ),
              )
            ],
          )),
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

    _pageController.animateToPage(index, curve: new ElasticInCurve(), duration: new Duration(microseconds: 200));
  }

  String _buildTitle() {
    return widget.eventGroup?.name ?? widget.title ?? widget.sport;
  }
}
