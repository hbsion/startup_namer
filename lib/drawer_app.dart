import 'package:flutter/material.dart';
import 'package:startup_namer/app_drawer.dart';
import 'package:startup_namer/pages/sport_page.dart';
import 'package:startup_namer/pages/home_page.dart';
import 'package:startup_namer/widgets/app_toolbar.dart';

class DrawerApp extends StatelessWidget {
  final appTitle = 'Play!';

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: appTitle,
      theme: new ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.black
      ),
      home: new HomePage()
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
  Widget page = new SportPage();
  final String title;

  _AppState(this.title);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new CustomScrollView(
        slivers: <Widget>[
          new AppToolbar(title: "Home"),
          page
        ],
      ),
      drawer: new AppDrawer(onSelect: (Widget page) {
        setState(() {
          this.page = page;
        });
      }
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
              icon: new Icon(Icons.all_inclusive), title: new Text("Hello"), backgroundColor: Colors.cyan),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.home), title: new Text("Hello"), backgroundColor: Colors.lightGreen),
        ],
      ),
    );
  }
}
