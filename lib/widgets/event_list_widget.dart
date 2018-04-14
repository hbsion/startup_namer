import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class EventListItemWidget extends StatelessWidget {

  const EventListItemWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
//        color: Color.fromARGB(255, 0Xf6, 0Xf6, 0Xf6),
        child: new Column(children: <Widget>[
          new Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: new InkWell(
                  onTap: () => print("List tap"),
                  child: new Row(children: <Widget>[
                    EventTimeWidget(),
                    new Expanded(child: new EventInfoWidget()),
                    new FavoriteWidget(),
                  ])
              )),
          new BetOfferWidget(),
          new Padding(padding: EdgeInsets.all(4.0)),
          new Divider(color: Color.fromARGB(255, 0xd1, 0xd1, 0xd1), height: 1.0)
        ]));
  }
}

class EventInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Column(children: <Widget>[new Text("Home"), new Text("Away"), new Text("path")]);
  }
}

class EventTimeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        width: 68.0,
        child: new Center(
            child: new Column(
                children: <Widget>[
                  new AnimatedCircularChart(
                    size: const Size(24.0, 24.0),
                    initialChartData: <CircularStackEntry>[
                      new CircularStackEntry(
                          <CircularSegmentEntry>[
                            new CircularSegmentEntry(30.0, Color.fromRGBO(0x00, 0xad, 0xc9, 1.0)),
                            new CircularSegmentEntry(70.0, Colors.grey[200]),
                          ]
                      )
                    ],
                    chartType: CircularChartType.Pie,
                  ),
                  new Text("12:34", style: Theme.of(context).textTheme.caption)
                ]))

    );
//    return new Text("17:00", style: Theme.of(context).textTheme.subhead);
  }
}

class FavoriteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new IconButton(icon: new Icon(Icons.star_border), onPressed: () {});
  }
}

class BetOfferWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Row(children: <Widget>[
      new Expanded(child: new Padding(padding: EdgeInsets.only(right: 4.0), child: new OutcomeWidget())),
      new Expanded(child: new Padding(padding: EdgeInsets.only(right: 4.0), child: new OutcomeWidget())),
      new Expanded(child: new OutcomeWidget()),
    ]);
  }
}

class OutcomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        height: 38.0,
        padding: EdgeInsets.all(3.0),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          color: Color.fromRGBO(0x00, 0xad, 0xc9, 1.0),
        ),
        child: new Material(
          color: Colors.transparent,
          child: new InkWell(
              onTap: () => print("outcome tap " + DateTime.now().toString()),
              child: new Row(
                children: <Widget>[
                  new Expanded(child: new Text("Home", style: new TextStyle(color: Colors.white, fontSize: 12.0))),
                  new Text("1.23", style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold))
                ],
              )),
        ));
  }
}
