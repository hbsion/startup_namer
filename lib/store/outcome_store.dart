import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/api/event_response.dart';
import 'package:startup_namer/data/outcome.dart';
import 'package:startup_namer/store/action_type.dart';
import 'package:startup_namer/store/store.dart';
import 'package:startup_namer/util/flowable.dart';

class OutcomeStore implements Store {
  final Map<int, BehaviorSubject<Outcome>> _outcomes = new HashMap();
  final Map<int, BehaviorSubject<List<Outcome>>> _outcomesByBetOffer = new HashMap();

  SnapshotObservable<Outcome> operator [](int id) {
    var subject = _outcomes[id];
    if (subject == null) {
      subject = new BehaviorSubject<Outcome>();
      _outcomes[id] = subject;
    }
    return new SnapshotObservable(subject.value, subject.observable);
  }

  SnapshotObservable<List<Outcome>> byBetOfferId(int id) {
    var subject = _outcomesByBetOffer [id];
    if (subject == null) {
      var outcomes = _outcomes.values.where((subject) => subject.value.betOfferId == id)
          .map((subject) => subject.value)
          .toList();

      subject = new BehaviorSubject<List<Outcome>>(seedValue: outcomes);
      subject.onCancel = () {
        if (!subject.hasListener) {
          _outcomesByBetOffer.remove(id);
          subject.close();
        }
      };
      _outcomesByBetOffer[id] = subject;
    }
    return new SnapshotObservable(subject.value, subject.observable);
  }

  List<Outcome> snapshot(List<int> ids) {
    return ids.map((id) => _outcomes[id])
        .where((subject) => subject != null)
        .map((subject) => subject.value)
        .toList(growable: false);
  }

  List<Outcome> snapshotByBetOffer(int betOfferId) {
    return _outcomes.values
        .where((subject) => subject.value != null && subject.value.betOfferId == betOfferId)
        .map((subject) => subject.value)
        .toList(growable: false);
  }

  @override
  void dispatch(ActionType type, action) {
    switch (type) {
      case ActionType.eventResponse:
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

        for (var betOffer in response.betoffers) {
          var subject = _outcomesByBetOffer[betOffer.id];

          if (subject != null && subject.hasListener) {
            var outcomes = betOffer.outcomes.map((id) => _outcomes[id])
                .map((subject) => subject.value)
                .where((outcome) => outcome != null)
                .toList();
            if (!new DeepCollectionEquality().equals(subject.value, outcomes)) {
              subject.add(outcomes);
            }
          }
        }


        break;
      default:
        break;
    }
  }

}