import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:svan_play/store/app_store.dart';
import 'package:svan_play/store/store_provider.dart';
import 'package:svan_play/util/callable.dart';

typedef Widget WidgetModelBuilder<T>(BuildContext context, T model);
typedef Observable<T> Mapper<T>(AppStore appStore);
typedef T Snapshot<T>(AppStore appStore);

class StoreConnector<T> extends StatelessWidget {
  final WidgetModelBuilder<T> widgetBuilder;
  final Mapper<T> stream;
  final Snapshot<T> initalData;
  final Callable<Dispatcher> pollAction;
  final Callable2<Dispatcher, AppStore> initAction;

  const StoreConnector(
      {Key key, @required this.widgetBuilder, this.stream, this.pollAction, this.initAction, this.initalData})
      : assert(widgetBuilder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new _StoreConnector(
      appStore: StoreProvider.of(context),
      builder: widgetBuilder,
      stream: stream,
      initalData: initalData,
      pollAction: pollAction,
      initAction: initAction,
    );
  }
}

class _StoreConnector<T> extends StatefulWidget {
  final AppStore appStore;
  final WidgetModelBuilder<T> builder;
  final Mapper<T> stream;
  final Snapshot<T> initalData;
  final Callable<Dispatcher> pollAction;
  final Callable2<Dispatcher, AppStore> initAction;

  const _StoreConnector(
      {Key key,
      @required this.builder,
      @required this.stream,
      this.pollAction,
      this.initAction,
      this.appStore,
      this.initalData})
      : assert(builder != null),
        assert(appStore != null),
        super(key: key);

  @override
  _State createState() => new _State<T>();
}

class _State<T> extends State<_StoreConnector<T>> with WidgetsBindingObserver {
  T _snapshot;
  StreamSubscription<T> _subscription;
  Timer _timer;

  @override
  void initState() {
    if (widget.initalData != null) {
      _snapshot = widget.initalData(widget.appStore);
    }
    if (widget.stream != null) {
      _subscription = widget.stream(widget.appStore).listen((data) {
        if (mounted && data != _snapshot) {
          setState(() {
            _snapshot = data;
          });
        }
      });
    }
    if (widget.pollAction != null) {
      widget.pollAction(widget.appStore.dispatch);
      _startPoller();
    }
    if (widget.initAction != null) {
      widget.initAction(widget.appStore.dispatch, widget.appStore);
    }
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && _timer != null) {
      _stopPoller();
    } else if (state == AppLifecycleState.resumed && widget.pollAction != null && _timer == null) {
      widget.pollAction(widget.appStore.dispatch);
      _startPoller();
      if (widget.initAction != null) {
        widget.initAction(widget.appStore.dispatch, widget.appStore);
      }
    }
  }

  void _startPoller() {
    _timer = new Timer.periodic(new Duration(seconds: 30), (_) => widget.pollAction(widget.appStore.dispatch));
  }

  void _stopPoller() {
    _timer.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
    if (_timer != null) {
      WidgetsBinding.instance.removeObserver(this);
      _stopPoller();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _snapshot);
  }
}
