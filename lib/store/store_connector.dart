import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:startup_namer/store/app_store.dart';
import 'package:startup_namer/store/store_provider.dart';
import 'package:startup_namer/util/callable.dart';
import 'package:startup_namer/util/flowable.dart';

typedef Widget WidgetModelBuilder<T>(BuildContext context, T model, AppStore store);
typedef Flowable<T> Mapper<T>(AppStore appStore);

class StoreConnector<T> extends StatelessWidget {
  final WidgetModelBuilder<T> builder;
  final Mapper<T> mapper;
  final Callable<Dispatcher> action;

  const StoreConnector({Key key, @required this.builder, @required this.mapper, this.action})
      :assert(builder != null),
        assert(mapper != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new _StoreConnector(
      appStore: StoreProvider.of(context),
      builder: builder,
      mapper: mapper,
      action: action,
    );
  }
}

class _StoreConnector<T> extends StatefulWidget {
  final AppStore appStore;
  final WidgetModelBuilder<T> builder;
  final Mapper<T> mapper;
  final Callable<Dispatcher> action;

  const _StoreConnector({Key key, @required this.builder, @required this.mapper, this.action, this.appStore})
      :assert(builder != null),
        assert(mapper != null),
        assert(appStore != null),
        super(key: key);

  @override
  _State createState() => new _State<T>();

}

class _State<T> extends State<_StoreConnector<T>> {
  T _snapshot;
  StreamSubscription<T> _subscription;

  @override
  void initState() {
    var mapper = widget.mapper(widget.appStore);
    _snapshot = mapper.value;
    _subscription = mapper.listen((data) {
      if (mounted && data != _snapshot) {
        setState(() {
          _snapshot = data;
        });
      }
    });
    if (widget.action != null) {
      widget.action(widget.appStore.dispatch);
    }
    super.initState();
  }

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
    return widget.builder(context, _snapshot, widget.appStore);
  }

}
