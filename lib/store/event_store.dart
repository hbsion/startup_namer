import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/data/event_response.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/store/action_type.dart';
import 'package:startup_namer/store/store.dart';
import 'package:startup_namer/util/flowable.dart';

class EventStore implements Store {
  final Map<int, BehaviorSubject<Event>> _events = new HashMap();

  SnapshotObservable<Event> operator[] (int id) {
    var subject = _events[id];
    if (subject == null) {
      subject = new BehaviorSubject<Event>();
      _events[id] = subject;
    }
    return new SnapshotObservable(subject.value, subject.observable);
  }

  List<Event> snapshot(Iterable<int> ids) {
    return ids.map((id) => _events[id])
        .where((subject) => subject != null)
        .map((subject) => subject.value)
        .toList(growable: false);
  }

  @override
  void dispatch(ActionType type, action) {
    switch (type) {
      case ActionType.eventResponse:
        EventResponse response = action;
        for (var event in response.events) {
          var subject = _events[event.id];
          if (subject != null) {
            if (subject.value != event) {
              subject.add(event);
            }
          } else {
            _events[event.id] = new BehaviorSubject<Event>(seedValue: event);
          }
        }
        break;

      default:
        break;
    }
  }

}