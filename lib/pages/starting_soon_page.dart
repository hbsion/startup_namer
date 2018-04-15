import 'package:flutter/material.dart';
import 'package:startup_namer/app_drawer.dart';
import 'package:startup_namer/widgets/app_toolbar.dart';

class StartingSoonPage extends StatelessWidget {
  final String title;

  StartingSoonPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new CustomScrollView(
          slivers: <Widget>[
            new AppToolbar(title: "Starting Soon"),
          ],
        ),
        drawer: new AppDrawer(onSelect: (Widget page) {}
        )
    );
  }
}
