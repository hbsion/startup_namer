import 'package:flutter/material.dart';
import 'package:startup_namer/app_drawer.dart';
import 'package:startup_namer/views/event_list_view.dart';
import 'package:startup_namer/widgets/app_toolbar.dart';

class StartingSoonPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new CustomScrollView(
          slivers: <Widget>[
            new AppToolbar(title: "Starting Soon"),
            new EventListView(
                sport: "all",
                league: "all",
                region: "all",
                participant: "all",
                filter: "starting-soon")
          ],
        ),
        drawer: new AppDrawer(onSelect: (Widget page) {}
        )
    );
  }
}
