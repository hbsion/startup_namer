import 'package:flutter/material.dart';
import 'package:startup_namer/app_drawer.dart';
import 'package:startup_namer/sport_page.dart';
import 'package:startup_namer/start_page.dart';

class DrawerApp extends StatelessWidget {
  final appTitle = 'Play!';

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: appTitle,
      home: new App(title: appTitle),
    );
  }
}

class App extends StatefulWidget {
  final String title;
  int page = 0;

  App({Key key, this.title}) : super(key: key);

  @override
  _AppState createState() {
    return new _AppState(title);
  }
}

class _AppState extends State<App> {
  Widget page = new StartPage();
  final String title;

  _AppState(this.title);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(title)),
        body: page,
        drawer: new AppDrawer(onSelect: (Widget page) {
          setState(() {
             this.page = page;
          });
        }));
  }
}
