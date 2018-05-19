import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:svan_play/push/push_hub.dart';
import 'package:svan_play/push/push_provider.dart';
import 'package:svan_play/store/app_store.dart';
import 'package:svan_play/util/callable.dart';

typedef Widget WidgetModelBuilder<T>(BuildContext context, T model);
typedef Observable<T> Mapper<T>(AppStore appStore);
typedef T Snapshot<T>(AppStore appStore);

class PushConnector<T> extends StatelessWidget {
  final Widget child;
  final List<String> topics;

  const PushConnector({Key key, @required this.child, this.topics})
      : assert(child != null),
        assert(topics != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new _PushConnector(
      pushHub: PushProvider.of(context),
      child: child,
      topics: topics
    );
  }
}

class _PushConnector<T> extends StatefulWidget {
  final PushHub pushHub;
  final Widget child;
  final List<String> topics;

  const _PushConnector(
      {Key key, @required this.child, @required this.topics, @required this.pushHub})
      : assert(child != null),
        assert(topics != null),
        assert(pushHub != null),
        super(key: key);

  @override
  _State createState() => new _State<T>();
}

class _State<T> extends State<_PushConnector<T>> with WidgetsBindingObserver {
  @override
  void initState() {
    widget.pushHub.subscribe(widget.topics);
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      widget.pushHub.unsubscribe(widget.topics);
    } else if (state == AppLifecycleState.resumed) {
      widget.pushHub.subscribe(widget.topics);
    }
  }

  @override
  void dispose() {
    widget.pushHub.unsubscribe(widget.topics);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
