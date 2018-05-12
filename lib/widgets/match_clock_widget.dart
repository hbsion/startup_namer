import 'dart:async';

import 'package:flutter/material.dart';
import 'package:startup_namer/data/match_clock.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/widgets/empty_widget.dart';

class MatchClockWidget extends StatelessWidget {
  final int eventId;

  const MatchClockWidget({Key key, this.eventId})
      : assert(eventId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<MatchClock>(
      mapper: (store) => store.statisticsStore.matchClock(eventId).observable,
      snapshot: (store) => store.statisticsStore.matchClock(eventId).last,
      widgetBuilder: _buildWidget,
    );
  }

  Widget _buildWidget(BuildContext context, MatchClock model) {
    if (model == null) {
      return new EmptyWidget();
    }

    if (model.running) {
      return new _TimeTickWidget(clock: model);
    } else {
      return _buildTimeWidget(context, model.minute, model.second);
    }
  }
}

Widget _buildTimeWidget(BuildContext context, int minute, int second) {
  String pad(int value) {
    return value.toString().padLeft(2, '0');
  }

  return new Text("${pad(minute)}:${pad(second)}", style: Theme.of(context).textTheme.caption);
}

class _TimeTickWidget extends StatefulWidget {
  final MatchClock clock;

  const _TimeTickWidget({Key key, this.clock}) : super(key: key);

  @override
  _TimeTickWidgetState createState() => new _TimeTickWidgetState();
}

class _TimeTickWidgetState extends State<_TimeTickWidget> {
  int _minute;
  int _second;
  Timer _timer;

  @override
  void initState() {
    _minute = widget.clock.minute;
    _second = widget.clock.second;
    _timer = new Timer.periodic(new Duration(seconds: 1), _timeTick);
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTimeWidget(context, _minute, _second);
  }

  void _timeTick(Timer timer) {
    if (mounted) {
      setState(() {
        var currentSecond = _second;
        _second = currentSecond == 59 ? 0 : currentSecond + 1;
        _minute = currentSecond == 59 ? _minute + 1 : _minute;
      });
    }
  }
}
