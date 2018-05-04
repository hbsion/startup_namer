import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:meta/meta.dart';
import 'package:startup_namer/util/dates.dart';

class CountDownWidget extends StatefulWidget {
  final DateTime time;
  final int minutes;

  const CountDownWidget({Key key, @required this.time, this.minutes = 15})
       : assert(time != null),
         super(key: key);

  _CountDownState createState() => new _CountDownState();
}

class _CountDownState extends State<CountDownWidget> {
  Timer _timer;

  @override
  void initState() {
    _timer = new Timer.periodic(new Duration(seconds: 1),  _tick);
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _tick(Timer _) {
    if (widget.time.isAfter(DateTime.now())) {
      setState((){});
    } else {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    var timeToStart = widget.time.difference(DateTime.now());
    double pc = (timeToStart.inMinutes / widget.minutes) * 100;

    return new Column(
        children: <Widget>[
          new AnimatedCircularChart(
            size: const Size(24.0, 24.0),
            initialChartData: <CircularStackEntry>[
              new CircularStackEntry(
                  <CircularSegmentEntry>[
                    new CircularSegmentEntry(100 - pc, Color.fromRGBO(0x00, 0xad, 0xc9, 1.0)),
                    new CircularSegmentEntry(pc, Colors.grey[200]),
                  ]
              )
            ],
            chartType: CircularChartType.Pie,
          ),
          new Text(formatDurationTime(timeToStart), style: Theme
              .of(context)
              .textTheme
              .caption)
        ]);
//    return new Text("17:00", style: Theme.of(context).textTheme.subhead);
  }
}