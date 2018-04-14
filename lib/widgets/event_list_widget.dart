import 'package:flutter/material.dart';

class EventListItemWidget extends StatelessWidget {

  const EventListItemWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: EdgeInsets.all(8.0),
        child: new Column(children: <Widget>[
          new InkWell(
              onTap: () => print("List tap"),
              child: new Row(children: <Widget>[
                EventTimeWidget(),
                new Expanded(child: new EventInfoWidget()),
                new FavoriteWidget(),
              ])
          ),
          new BetOfferWidget(),
          new Divider()
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
    return new Text("17:00", style: Theme
        .of(context)
        .textTheme
        .subhead);
  }
}

class FavoriteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Text("S", style: Theme
        .of(context)
        .textTheme
        .subhead);
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
      child: new InkWell(
          onTap: () => print("outcome tap " + DateTime.now().toString()),
          child: new Row(
            children: <Widget>[
              new Expanded(child: new Text("Home", style: new TextStyle(color: Colors.white))),
              new Text("1.23", style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
            ],
          )),
    );
  }
}
