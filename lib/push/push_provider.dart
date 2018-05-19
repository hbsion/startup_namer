import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:svan_play/push/push_hub.dart';

class PushProvider extends InheritedWidget {
  final PushHub _pushHub;

  const PushProvider({
    Key key,
    @required PushHub pushHub,
    @required Widget child,
  })  : assert(pushHub != null),
        assert(child != null),
        _pushHub = pushHub,
        super(key: key, child: child);

  static PushHub of(BuildContext context) {
    final type = _typeOf<PushProvider>();
    final PushProvider provider = context.inheritFromWidgetOfExactType(type);

    if (provider == null) throw new PushProviderError(type);

    return provider._pushHub;
  }

  // Workaround to capture generics
  static Type _typeOf<T>() => T;

  @override
  bool updateShouldNotify(PushProvider old) => _pushHub != old._pushHub;
}

class PushProviderError extends Error {
  Type type;

  PushProviderError(this.type);

  String toString() {
    return 'Error: No $type found';
  }
}
