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
              flexibleSpace: new Stack(
                alignment: const Alignment(-0.6, 0.5),
                children: <Widget>[
                  new Row(children: <Widget>[
                    new Expanded(child: new Image.asset('assets/banner_1.jpg', fit: BoxFit.cover, height: 80.0)),
                  ]),
                  new Text(
                      "Home",
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 21.0,
                          fontWeight: FontWeight.w500
                      )
                  )
                ],
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
