import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:meta/meta.dart';

class EventTimeWidget extends StatelessWidget {
  final int eventId;

  const EventTimeWidget({Key key, @required this.eventId}) : assert(eventId != null), super(key: key);

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
                  new Text("12:34", style: Theme
                      .of(context)
                      .textTheme
                      .caption)
                ]))

    );
//    return new Text("17:00", style: Theme.of(context).textTheme.subhead);
  }
}