import 'package:flutter/material.dart';
import 'package:svan_play/app_drawer.dart';
import 'package:svan_play/views/event_list_view.dart';
import 'package:svan_play/widgets/app_toolbar.dart';

class StartingSoonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new CustomScrollView(
          slivers: <Widget>[
            new AppToolbar(title: "Starting Soon"),
            new EventListView(sport: "all", league: "all", region: "all", participant: "all", filter: "starting-soon")
          ],
        ),
        drawer: new AppDrawer(onSelect: (Widget page) {}));
  }
}
