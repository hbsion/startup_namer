import 'package:flutter/material.dart';
import 'package:startup_namer/app_drawer.dart';
import 'package:startup_namer/sport_page.dart';

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
  Widget page = new SportPage();
  final String title;

  _AppState(this.title);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //appBar: new AppBar(title: new Text(title)),
        body: new CustomScrollView(
          slivers: <Widget>[
            new SliverAppBar(
              expandedHeight: 56.0,
              pinned: false,
              floating: true,
              snap: false,
              //_appBarBehavior == AppBarBehavior.snapping,
              flexibleSpace: new FlexibleSpaceBar(
                title: const Text('Svan Play!'),
                background: new Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    new Image.asset('assets/banner.jpg', fit: BoxFit.cover, height: 56.0),
                  ],
                ),
              ),
            ),
            page
          ],
        ),
        drawer: new AppDrawer(onSelect: (Widget page) {
          setState(() {
            this.page = page;
          });
        }
        )
    );
  }
}
