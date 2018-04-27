import 'dart:async';

import 'package:rxdart/rxdart.dart';

class Flowable<T> extends Stream<T> {
  final BehaviorSubject<T> _subject;

  Flowable(this._subject);

  @override
  StreamSubscription<T> listen(void Function(T event) onData,
      {Function onError, void Function() onDone, bool cancelOnError}) {
    return _subject.observable.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  T get value => _subject.value;
}