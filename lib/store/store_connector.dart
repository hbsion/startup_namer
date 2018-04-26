import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/store/app_store.dart';
import 'package:startup_namer/store/store_provider.dart';
import 'package:startup_namer/util/callable.dart';

typedef Widget WidgetModelBuilder<T>(BuildContext context, T model);
typedef Observable<T> Mapper<T>(AppStore appStore);

class StoreConnector<T> extends StatefulWidget {
  final WidgetModelBuilder<T> builder;
  final Mapper<T> mapper;
  final Callable<Dispatcher> action;

  const StoreConnector({Key key, @required this.builder, @required this.mapper, this.action})
      :assert(builder != null),
        assert(mapper != null),
        super(key: key);

  @override
  _State createState() => new _State<T>();

}

class _State<T> extends State<StoreConnector<T>> {
  T _snapshot;
  StreamSubscription<T> _subscription;
  AppStore _appStore;


  @override
  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }
    super.dispose();
  }


  @override
  void deactivate() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
    super.deactivate();
  }


  @override
  Widget build(BuildContext context) {
    if (_appStore == null) {
      _appStore = StoreProvider.of(context);
      _subscription = widget.mapper(_appStore).listen((data) {
        if (mounted) {
          setState(() {
            _snapshot = data;
          });
        }
      });
      if (widget.action != null) {
        widget.action(_appStore.dispatch);
      }
    }
    return widget.builder(context, _snapshot);
  }

}
