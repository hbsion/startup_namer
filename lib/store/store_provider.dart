import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:startup_namer/store/app_store.dart';

class StoreProvider extends InheritedWidget {
  final AppStore _store;

  const StoreProvider({
    Key key,
    @required AppStore store,
    @required Widget child,
  })  : assert(store != null),
        assert(child != null),
        _store = store,
        super(key: key, child: child);

  static AppStore of(BuildContext context) {
    final type = _typeOf<StoreProvider>();
    final StoreProvider provider =
        context.inheritFromWidgetOfExactType(type);

    if (provider == null) throw new StoreProviderError(type);

    return provider._store;
  }

  // Workaround to capture generics
  static Type _typeOf<T>() => T;

  @override
  bool updateShouldNotify(StoreProvider old) => _store != old._store;
}

class StoreProviderError extends Error {
  Type type;

  StoreProviderError(this.type);

  String toString() {
    return 'Error: No $type found';
  }
}