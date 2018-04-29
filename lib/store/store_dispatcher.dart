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

class StoreDispatcher<T> extends StatelessWidget {
  final Widget child;
  final Callable<Dispatcher> action;

  const StoreDispatcher({Key key, @required this.child, @required this.action})
      :assert(child != null),
        assert(action != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new _StoreDispatcher(
      appStore: StoreProvider.of(context),
      child: child,
      action: action,
    );
  }
}

class _StoreDispatcher<T> extends StatefulWidget {
  final AppStore appStore;
  final Widget child;
  final Callable<Dispatcher> action;

  const _StoreDispatcher({Key key, @required this.child, @required this.action, @required this.appStore})
      :assert(child != null),
        assert(action != null),
        assert(appStore != null),
        super(key: key);

  @override
  _State createState() => new _State<T>();
}

class _State<T> extends State<_StoreDispatcher<T>> with WidgetsBindingObserver {
  Timer _timer;

  @override
  void initState() {
    widget.action(widget.appStore.dispatch);
    _startPoller();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && _timer != null) {
      _stopPoller();
    } else if (state == AppLifecycleState.resumed && _timer == null) {
      _startPoller();
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

  @override
  void deactivate() {
    _dispose();
    super.deactivate();
  }

  void _dispose() {
    if (_timer != null) {
      WidgetsBinding.instance.removeObserver(this);
      _stopPoller();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

}
