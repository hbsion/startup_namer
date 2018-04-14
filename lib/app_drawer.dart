import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:startup_namer/callable.dart';

class MenuEntry {
  final String title;
  final String sport;
  final String league;
  final String region;
  final int count;

  MenuEntry({this.title, this.sport, this.league, this.region, this.count = 0});
}

final List<MenuEntry> highlights = [
  new MenuEntry(title: "Odds Lobby"),
  new MenuEntry(title: "Live Right Now"),
  new MenuEntry(title: "Starting Soon"),
];

final popular = [
  new MenuEntry(sport: "Football", region: "Sweden", league: "Allsvenskan", count: 1569),
  new MenuEntry(sport: "Football", region: "Sweden", league: "Superettan", count: 1005),
  new MenuEntry(sport: "Football", region: "England", league: "Premier League", count: 3987),
  new MenuEntry(sport: "Football", region: "Italy", league: "Serie A", count: 1178),
  new MenuEntry(sport: "Football", region: "Spain", league: "LaLiga", count: 2236),
  new MenuEntry(sport: "Ice Hockey", region: "Sweden", league: "SHL", count: 111),
  new MenuEntry(sport: "Ice Hockey", league: "NHL", count: 1231),
  new MenuEntry(sport: "Basketball", league: "NBA", count: 10),
  new MenuEntry(sport: "Tennis", count: 182),
];

final sports = [
  new MenuEntry(sport: "Football", count: 73020),
  new MenuEntry(sport: "Ice Hockey", count: 2545),
  new MenuEntry(sport: "Tennis", count: 182),
  new MenuEntry(sport: "Trotting", count: 92),
  new MenuEntry(sport: "Golf", count: 40),
  new MenuEntry(sport: "Basketball", count: 2541),
  new MenuEntry(sport: "Handball", count: 347),
  new MenuEntry(sport: "UFC/MMA", count: 180),
];

final moreSports = [
  new MenuEntry(sport: "American Fotball", count: 14),
  new MenuEntry(sport: "Australian Rules", count: 1180),
  new MenuEntry(sport: "Baseball", count: 427),
  new MenuEntry(sport: "Boxing", count: 50),
  new MenuEntry(sport: "Chess", count: 3),
  new MenuEntry(sport: "Commonswealth Games", count: 236),
  new MenuEntry(sport: "Cricket", count: 105),
  new MenuEntry(sport: "Darts", count: 232),
  new MenuEntry(sport: "Floorball", count: 28),
  new MenuEntry(sport: "Futsal", count: 17),
  new MenuEntry(sport: "Gaelic Sports", count: 21),
  new MenuEntry(sport: "Greyhounds", count: 207),
  new MenuEntry(sport: "Horse Racing", count: 209),
  new MenuEntry(sport: "Motorsports", count: 58),
  new MenuEntry(sport: "Netball", count: 1),
  new MenuEntry(sport: "Olympic Games", count: 1),
  new MenuEntry(sport: "Pesapallo", count: 1),
  new MenuEntry(sport: "Politics", count: 51),
  new MenuEntry(sport: "Rugby League", count: 1041),
  new MenuEntry(sport: "Rugby Union", count: 483),
  new MenuEntry(sport: "Snooker", count: 96),
  new MenuEntry(sport: "Surfing", count: 22),
  new MenuEntry(sport: "TV & Novelty", count: 22),
  new MenuEntry(sport: "Volleyball", count: 22),
  new MenuEntry(sport: "Winter Olympic Games", count: 1),
  new MenuEntry(sport: "Winter Sports", count: 7),
];

class AppDrawer extends StatelessWidget {
  final String title;
  final Callable<Widget> onSelect;

  AppDrawer({Key key, this.title, @required this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new AppMenu(),
    );
  }
}

class MenuEntryRow extends StatelessWidget {
  final MenuEntry entry;

  MenuEntryRow(this.entry);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    List<Widget> row = [];
    if (entry.title != null) {
      row.add(new Text(entry.title));
    } else if (entry.league != null) {
      row.add(new Text(entry.league));
      row.add(new Padding(
          padding: EdgeInsets.only(left: 4.0), child: new Text(entry.sport, style: theme.textTheme.caption)));
      if (entry.region != null) {
        row.add(new Padding(padding: EdgeInsets.only(left: 2.0), child: new Text("/", style: theme.textTheme.caption)));
        row.add(new Padding(
            padding: EdgeInsets.only(left: 2.0), child: new Text(entry.region, style: theme.textTheme.caption)));
      }
    } else {
      row.add(new Text(entry.sport));
    }

    return new InkWell(
        child: new Padding(
          padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
          child: Row(
            children: <Widget>[
              new Expanded(child: new Row(children: row, crossAxisAlignment: CrossAxisAlignment.end)),
              new Text(entry.count.toString(), style: Theme
                  .of(context)
                  .textTheme
                  .caption)
            ],
          ),
        ),
        onTap: () => print("Tapapapa"));
  }
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class AppMenu extends StatelessWidget {
  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final double _appBarHeight = 150.0;

  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  @override
  Widget build(BuildContext context) {
    List<Widget> entries = [
      new ExpansionTile(
          title: new Text("Home"),
          initiallyExpanded: true,
          children: highlights.map((entry) => new MenuEntryRow(entry)).toList()),
      new ExpansionTile(
          title: new Text("Popular"),
          initiallyExpanded: true,
          children: popular.map((entry) => new MenuEntryRow(entry)).toList()),
      new ExpansionTile(
          title: new Text("Sports"),
          initiallyExpanded: true,
          children: sports.map((entry) => new MenuEntryRow(entry)).toList()),
      new ExpansionTile(
          title: new Text("More Sports"),
          initiallyExpanded: true,
          children: moreSports.map((entry) => new MenuEntryRow(entry)).toList()),
    ];

    return new Theme(
      data: new ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        platform: Theme.of(context).platform,
      ),
      child: new Scaffold(
        key: _scaffoldKey,
        body: new CustomScrollView(
          slivers: <Widget>[
            new SliverAppBar(
              expandedHeight: _appBarHeight,
              pinned: false, //_appBarBehavior == AppBarBehavior.pinned,
              floating: true, //_appBarBehavior == AppBarBehavior.floating || _appBarBehavior == AppBarBehavior.snapping,
              snap: false, //_appBarBehavior == AppBarBehavior.snapping,
              flexibleSpace: new FlexibleSpaceBar(
                title: const Text('Svan Play!'),
                background: new Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    new Image.asset('assets/banner.jpg', fit: BoxFit.cover, height: _appBarHeight),
                  ],
                ),
              ),
            ),
            new SliverList(delegate: new SliverChildListDelegate(entries)),
          ],
        ),
      ),
    );
  }
}
