import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/store/app_store.dart';
import 'package:startup_namer/store/store_provider.dart';
import 'package:startup_namer/util/callable.dart';

typedef Widget WidgetModelBuilder<T>(BuildContext context, T model);
typedef Observable<T> Mapper<T>(AppStore appStore);
typedef T Snapshot<T>(AppStore appStore);

class StoreConnector<T> extends StatelessWidget {
  final WidgetModelBuilder<T> widgetBuilder;
  final Mapper<T> mapper;
  final Snapshot<T> snapshot;
  final Callable<Dispatcher> action;
  final Callable2<Dispatcher, AppStore> oneshotAction;

  const StoreConnector(
      {Key key, @required this.widgetBuilder, @required this.mapper, this.action, this.oneshotAction, this.snapshot})
      : assert(widgetBuilder != null),
        assert(mapper != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new _StoreConnector(
      appStore: StoreProvider.of(context),
      builder: widgetBuilder,
      mapper: mapper,
      snapshot: snapshot,
      action: action,
      oneshotAction: oneshotAction,
    );
  }
}

class _StoreConnector<T> extends StatefulWidget {
  final AppStore appStore;
  final WidgetModelBuilder<T> builder;
  final Mapper<T> mapper;
  final Snapshot<T> snapshot;
  final Callable<Dispatcher> action;
  final Callable2<Dispatcher, AppStore> oneshotAction;

  const _StoreConnector(
      {Key key,
      @required this.builder,
      @required this.mapper,
      this.action,
      this.oneshotAction,
      this.appStore,
      this.snapshot})
      : assert(builder != null),
        assert(mapper != null),
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
    if (widget.snapshot != null) {
      _snapshot = widget.snapshot(widget.appStore);
    }
    _subscription = widget.mapper(widget.appStore).listen((data) {
      if (mounted && data != _snapshot) {
        setState(() {
          _snapshot = data;
        });
      }
    });
    if (widget.action != null) {
      widget.action(widget.appStore.dispatch);
      _startPoller();
    }
    if (widget.oneshotAction != null) {
      widget.oneshotAction(widget.appStore.dispatch, widget.appStore);
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
    print("Lifecycle changed: " + state.toString());
    if (state == AppLifecycleState.paused && _timer != null) {
      _stopPoller();
    } else if (state == AppLifecycleState.resumed && widget.action != null && _timer == null) {
      widget.action(widget.appStore.dispatch);
      _startPoller();
      if (widget.oneshotAction != null) {
        widget.oneshotAction(widget.appStore.dispatch, widget.appStore);
      }
    }
  }

  void _startPoller() {
    _timer = new Timer.periodic(new Duration(seconds: 30), (_) => widget.action(widget.appStore.dispatch));
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
