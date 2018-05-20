import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:svan_play/data/betoffer.dart';
import 'package:svan_play/data/event_response.dart';
import 'package:svan_play/data/outcome.dart';
import 'package:svan_play/data/push/betoffer_added.dart';
import 'package:svan_play/data/push/odds_update.dart';
import 'package:svan_play/store/action_type.dart';
import 'package:svan_play/store/store.dart';
import 'package:svan_play/util/flowable.dart';

class OutcomeStore implements Store {
  final Map<int, BehaviorSubject<Outcome>> _outcomes = new HashMap();
  final Map<int, BehaviorSubject<List<Outcome>>> _outcomesByBetOffer = new HashMap();

  SnapshotObservable<Outcome> operator [](int id) {
    var subject = _outcomes[id];
    if (subject == null) {
      subject = new BehaviorSubject<Outcome>();
      _outcomes[id] = subject;
    }
    return new SnapshotObservable(subject.value, subject.stream);
  }

  SnapshotObservable<List<Outcome>> byBetOfferId(int id) {
    var subject = _outcomesByBetOffer[id];
    if (subject == null) {
      var outcomes =
          _outcomes.values.where((subject) => subject.value.betOfferId == id).map((subject) => subject.value).toList();

      subject = new BehaviorSubject<List<Outcome>>(seedValue: outcomes);
      subject.onCancel = () {
        if (!subject.hasListener) {
          _outcomesByBetOffer.remove(id);
          subject.close();
        }
      };
      _outcomesByBetOffer[id] = subject;
    }
    return new SnapshotObservable(subject.value, subject.stream);
  }

  List<Outcome> snapshot(List<int> ids) {
    return ids
        .map((id) => _outcomes[id])
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
      case ActionType.betOfferResponse:
        EventResponse response = action;
        _mergeOutcomes(response.outcomes);
        _mergeOutccomeByBetOffer(response.betoffers);
        break;
      case ActionType.oddsUpdate:
        OddsUpdate oddsUpdate = action;
        _handleOddsUpdate(oddsUpdate);
        break;
      case ActionType.betOfferAdded:
        BetOfferAdded added = action;
        _mergeOutcomes(added.outcomes);
        _mergeOutccomeByBetOffer([added.betOffer]);
        break;

      default:
        break;
    }
  }

  void _mergeOutccomeByBetOffer(List<BetOffer> betOffers) {
    for (var betOffer in betOffers) {
      var subject = _outcomesByBetOffer[betOffer.id];

      if (subject != null && subject.hasListener) {
        var outcomes = betOffer.outcomes
            .map((id) => _outcomes[id])
            .map((subject) => subject.value)
            .where((outcome) => outcome != null)
            .toList();
        if (!new DeepCollectionEquality().equals(subject.value, outcomes)) {
          subject.add(outcomes);
        }
      }
    }
//    logOutcomes();
  }

  void _mergeOutcomes(List<Outcome> outcomes) {
    for (var outcome in outcomes) {
      var subject = _outcomes[outcome.id];
      if (subject != null) {
        if (subject.value != outcome) {
          if (subject.value != null) {
            outcome.lastOdds = subject.value.odds;
            outcome.oddsChanged = DateTime.now();
          }
          subject.add(outcome);
        }
      } else {
        _outcomes[outcome.id] = new BehaviorSubject<Outcome>(seedValue: outcome);
      }
    }
  }

  void _logOutcomes() {
    int count = 0;
    for (var subject in _outcomes.values.where((s) => s.hasListener)) {
      print("Outcome id ${subject.value.id} has listeners ${subject.hasListener}");
      count++;
    }
    print("total $count");
  }

  void _handleOddsUpdate(OddsUpdate oddsUpdate) {
    for (var update in oddsUpdate.outcomes) {
      var subject = _outcomes[update.id];
      if (subject != null && subject.value != null) {
        var withNewOdds = subject.value.withNewOdds(update.odds);
        subject.add(withNewOdds);
      }
    }
  }
}
