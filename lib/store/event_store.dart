import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/api/event_response.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/store/action_type.dart';
import 'package:startup_namer/store/store.dart';
import 'package:startup_namer/util/flowable.dart';

class EventStore implements Store {
  final Map<int, BehaviorSubject<Event>> _events = new HashMap();

  Flowable<Event> event(int id) {
    var subject = _events[id];
    if (subject == null) {
      subject = new BehaviorSubject<Event>();
      _events[id] = subject;
    }
    return new Flowable(subject);
  }

  List<Event> snapshot(List<int> ids) {
    return _events.values.map((subject) => subject.value)
        .where((e) => e != null)
        .toList(growable: false);
  }

  @override
  void dispatch(ActionType type, action) {
    switch (type) {
      case ActionType.EventResponse:
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