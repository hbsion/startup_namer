import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:startup_namer/app_drawer.dart';
import 'package:startup_namer/models/main_model.dart';
import 'package:startup_namer/widgets/app_toolbar.dart';

class StartingSoonePage extends StatelessWidget {

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
