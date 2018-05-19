import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:svan_play/store/app_store.dart';
import 'package:svan_play/store/store_provider.dart';
import 'package:svan_play/util/callable.dart';

class StoreDispatcher<T> extends StatelessWidget {
  final Widget child;
  final Callable<Dispatcher> pollAction;
  final Callable<Dispatcher> initAction;

  const StoreDispatcher({Key key, @required this.child, @required this.pollAction, this.initAction})
      :assert(child != null),
        assert(pollAction != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new _StoreDispatcher(
      appStore: StoreProvider.of(context),
      child: child,
      poll: pollAction,
      oneshot: initAction,
    );
  }
}

class _StoreDispatcher<T> extends StatefulWidget {
  final AppStore appStore;
  final Widget child;
  final Callable<Dispatcher> poll;
  final Callable<Dispatcher> oneshot;

  const _StoreDispatcher({Key key, @required this.child, @required this.poll, @required this.appStore, this.oneshot})
      :assert(child != null),
        assert(poll != null),
        assert(appStore != null),
        super(key: key);

  @override
  _State createState() => new _State<T>();
}

class _State<T> extends State<_StoreDispatcher<T>> with WidgetsBindingObserver {
  Timer _timer;

  @override
  void initState() {
    widget.poll(widget.appStore.dispatch);
    if (widget.oneshot != null) {
      widget.oneshot(widget.appStore.dispatch);
    }
    _startPoller();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && _timer != null) {
      _stopPoller();
    } else if (state == AppLifecycleState.resumed && _timer == null) {
      widget.poll(widget.appStore.dispatch);
      if (widget.oneshot != null) {
        widget.oneshot(widget.appStore.dispatch);
      }
      _startPoller();
    }
  }

  void _startPoller() {
    _timer = new Timer.periodic(new Duration(seconds: 30), (_) => widget.poll(widget.appStore.dispatch));
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
