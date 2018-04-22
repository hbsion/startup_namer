import 'package:flutter/material.dart';
import 'package:startup_namer/api/offering_api.dart';

class AppToolbar extends StatelessWidget {
  final String title;
  final VoidCallback onNavPress;

  const AppToolbar({Key key, this.title, this.onNavPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SliverAppBar(
      expandedHeight: 56.0,
      pinned: false,
      floating: true,
      snap: false,
      actions: <Widget>[
        new IconButton(icon: const Icon(Icons.search), onPressed: _search(context))
      ],
      leading: onNavPress != null ? new IconButton(icon: new Icon(Icons.dehaze), onPressed: onNavPress) : null,
      flexibleSpace: new Stack(
        alignment: const Alignment(-0.6, 0.5),
        children: <Widget>[
          new Row(children: <Widget>[
            new Expanded(child: new Image.asset('assets/banner_1.jpg', fit: BoxFit.cover, height: 80.0)),
          ]),
          new Text(
              title,
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 21.0,
                  fontWeight: FontWeight.w500
              )
          )
        ],
      ),
    );
  }

  VoidCallback _search(BuildContext context) {
    return () async {
//      Navigator.of(context).push(new MaterialPageRoute(
//          builder: (context) => new SearchView()
//      )
//      );
      var eventResponse = await fetchListView(sport: "football", region: "england", league: "premier_league");
      print(eventResponse);
    };
  }
}