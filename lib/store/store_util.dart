import 'package:rxdart/rxdart.dart';
import 'package:svan_play/util/flowable.dart';

SnapshotObservable<T> getOrCreateSubject<K, T>(K id, Map<K, BehaviorSubject<T>> subjects) {
  var subject = subjects[id];
  if (subject == null) {
    subject = new BehaviorSubject<T>();
    subjects[id] = subject;
  }
  return new SnapshotObservable(subject.value, subject.stream);
}

void merge<K, V>(K id, V value, Map<K, BehaviorSubject<V>> subjects, {bool ignoreIfNotFound = false}) {
  var subject = subjects[id];
  if (subject != null) {
    if (subject.value != value && value != null) {
      subject.add(value);
    }
  } else if (value != null && !ignoreIfNotFound) {
    subjects[id] = new BehaviorSubject<V>(seedValue: value);
  }
}
