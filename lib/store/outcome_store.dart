import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/api/event_response.dart';
import 'package:startup_namer/data/betoffer.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/outcome.dart';
import 'package:startup_namer/store/action_type.dart';
import 'package:startup_namer/store/store.dart';
import 'package:startup_namer/util/flowable.dart';

class OutcomeStore implements Store {
  final Map<int, BehaviorSubject<Outcome>> _outcomes = new HashMap();

  SnapshotObservable<Outcome> operator[](int id) {
    var subject = _outcomes[id];
    if (subject == null) {
      subject = new BehaviorSubject<Outcome>();
      _outcomes[id] = subject;
    }
    return new SnapshotObservable(subject.value, subject.observable);
  }

  List<Outcome> snapshot(List<int> ids) {
    return ids.map((id) => _outcomes[id])
        .where((subject) => subject != null)
        .map((subject) => subject.value)
        .toList(growable: false);
  }

  @override
  void dispatch(ActionType type, action) {
    switch (type) {
      case ActionType.EventResponse:
        EventResponse response = action;
        for (var outcome in response.outcomes) {
          var subject = _outcomes[outcome.id];
          if (subject != null) {
            if (subject.value != outcome) {
              subject.add(outcome);
            }
          } else {
            _outcomes[outcome.id] = new BehaviorSubject<Outcome>(seedValue: outcome);
          }
        }
        break;
      default:
        break;
    }
  }

}