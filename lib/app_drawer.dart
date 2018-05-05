import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/data/event_group.dart';
import 'package:startup_namer/pages/home_page.dart';
import 'package:startup_namer/pages/live_right_now_page.dart';
import 'package:startup_namer/pages/mock_page.dart';
import 'package:startup_namer/pages/settings_page.dart';
import 'package:startup_namer/pages/sport_page.dart';
import 'package:startup_namer/pages/starting_soon_page.dart';
import 'package:startup_namer/store/app_store.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/util/callable.dart';
import 'package:startup_namer/widgets/empty_widget.dart';

class AppDrawer extends StatelessWidget {
  final String title;
  final Callable<Widget> onSelect;

  AppDrawer({Key key, this.title, this.onSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new AppMenu(),
    );
  }
}

class MenuEntryRow extends StatelessWidget {
  final _MenuEntry entry;

  MenuEntryRow(this.entry);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    List<Widget> row = [];
    if (entry.title != null) {
      row.add(new Text(entry.title));
    } else if (entry._league != null) {
      row.add(new Text(entry._league.name));
      row.add(new Padding(
          padding: EdgeInsets.only(left: 4.0), child: new Text(entry._sport.name, style: theme.textTheme.caption)));
      if (entry._region != null) {
        row.add(new Padding(padding: EdgeInsets.only(left: 2.0), child: new Text("/", style: theme.textTheme.caption)));
        row.add(new Padding(
            padding: EdgeInsets.only(left: 2.0), child: new Text(entry._region.name, style: theme.textTheme.caption)));
      }
    } else if (entry._region != null) {
      row.add(new Text(entry._region.name));
      row.add(new Padding(
          padding: EdgeInsets.only(left: 4.0), child: new Text(entry._sport.name, style: theme.textTheme.caption)));
    } else {
      row.add(new Text(entry._sport.name));
    }

    return new InkWell(
        child: new Padding(
          padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
          child: Row(
            children: <Widget>[
              new Expanded(child: new Row(children: row, crossAxisAlignment: CrossAxisAlignment.end)),
              entry.eventGroup != null ? new Text(entry.eventGroup.boCount.toString(), style: Theme
                  .of(context)
                  .textTheme
                  .caption)
                  : new EmptyWidget()
            ],
          ),
        ),
        onTap: _navigate(context, entry)
    );
  }

  _navigate(BuildContext context, _MenuEntry entry) {
    return () {
      Navigator.pop(context);
      Navigator.of(context).push(new MaterialPageRoute(builder: entry.builder ?? (context) =>
      new SportPage(
        sport: entry._sport != null ? entry._sport.termKey : "all",
        league: entry._league != null ? entry._league.termKey : "all",
        region: entry._region != null ? entry._region.termKey : "all",
      )));
    };
  }
}

class AppMenu extends StatelessWidget {
  final double _appBarHeight = 150.0;

  @override
  Widget build(BuildContext context) {
    return new Theme(
      data: new ThemeData(
          brightness: Brightness.dark,
          accentColor: Theme
              .of(context)
              .accentColor,
          platform: Theme
              .of(context)
              .platform)
      ,
      child: new Scaffold(
        //key: _scaffoldKey,
        body: new CustomScrollView(
          slivers: <Widget>[
            _buildAppBar(context),
            new StoreConnector<_ViewModel>(
                mapper: _mapStateToViewModel,
                widgetBuilder: _buildBody
            )
          ],
        ),
      ),
    );
  }

  Observable<_ViewModel> _mapStateToViewModel(AppStore store) {
    return new Observable.just(new _ViewModel(
        store.groupStore.sports,
        store.groupStore.highlights
    ));
  }

  SliverList _buildBody(BuildContext context, _ViewModel viewModel) {
    List<ExpansionTile> tiles = [
      new ExpansionTile(
          title: new Text("Home"),
          initiallyExpanded: true,
          children: home.map((entry) => new MenuEntryRow(entry)).toList()),
    ];

    if (viewModel != null) {
      List<EventGroup> sports = viewModel.sports.where((eg) => eg.sortOrder < 100).toList();
      sports.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      List<EventGroup> moreSports = viewModel.sports.where((eg) => eg.sortOrder >= 100).toList();
      moreSports.sort((a, b) => a.name.compareTo(b.name));

      tiles.addAll([
        new ExpansionTile(
            title: new Text("Popular"),
            initiallyExpanded: true,
            children: viewModel.highlights.map((eg) => new MenuEntryRow(new _MenuEntry(eventGroup: eg))).toList()),
        new ExpansionTile(
            title: new Text("Sports"),
            initiallyExpanded: true,
            children: sports.map((eg) => new MenuEntryRow(new _MenuEntry(eventGroup: eg))).toList()),
        new ExpansionTile(
            title: new Text("More Sports"),
            initiallyExpanded: true,
            children: moreSports.map((eg) => new MenuEntryRow(new _MenuEntry(eventGroup: eg))).toList()),

      ]);
    }

    return new SliverList(
        delegate: new SliverChildListDelegate(tiles)
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return new SliverAppBar(
        expandedHeight: _appBarHeight,
        pinned: false,
        floating: true,
        snap: false,
        flexibleSpace: new FlexibleSpaceBar(
          title: new Text("Svan Play!"),
          background: new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Image.asset('assets/banner.jpg', fit: BoxFit.cover, height: _appBarHeight),
            ],
          ),
        ),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.create),
            tooltip: 'Edit',
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => new SettingsPage())
              );
            },
          ),
        ]
    );
  }
}

class _ViewModel {
  final List<EventGroup> sports;
  final List<EventGroup> highlights;

  _ViewModel(this.sports, this.highlights);
}

class _MenuEntry {
  final String title;
  final EventGroup eventGroup;
  final WidgetBuilder builder;
  EventGroup _sport;
  EventGroup _region;
  EventGroup _league;

  _MenuEntry({
    this.title,
    this.builder,
    this.eventGroup
  }) {
    if (eventGroup != null) {
      // fucking tree
      if (eventGroup.parent.isRoot) {
        _sport = eventGroup;
      } else if (eventGroup.parent.parent.isRoot) {
        _sport = eventGroup.parent;
        _region = eventGroup;
      } else {
        _sport = eventGroup.parent.parent;
        _region = eventGroup.parent;
        _league = eventGroup;
      }
    }
  }
}

final List<_MenuEntry> home = [
  new _MenuEntry(title: "Start", builder: (context) => new HomePage()),
  new _MenuEntry(title: "Live Right Now", builder: (context) => new LiveRightNowPage()),
  new _MenuEntry(title: "Starting Soon", builder: (context) => new StartingSoonPage()),
];
