import 'dart:collection';

import 'package:startup_namer/api/event_response.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/store/Store.dart';
import 'package:startup_namer/store/action_type.dart';
import 'package:rxdart/rxdart.dart';


class EventStore implements Store {
  final Map<int, BehaviorSubject<Event>> _events = new HashMap();

  Observable<Event> event(int id) {
    var subject = _events[id];
    if (subject == null) {
      subject = new BehaviorSubject<Event>();
      _events[id];
    }
    return subject.observable;
  }

  @override
  void dispatch(ActionType type, action) {
    switch(type) {
      case ActionType.EventResponse:

        break;

      default:
        break;
    }
  }

}