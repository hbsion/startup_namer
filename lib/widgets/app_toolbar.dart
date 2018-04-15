import 'package:flutter/material.dart';

class AppToolbar extends StatelessWidget {
  final String title;

  const AppToolbar({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SliverAppBar(
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
}