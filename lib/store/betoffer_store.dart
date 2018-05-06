import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/data/betoffer.dart';
import 'package:startup_namer/data/event_response.dart';
import 'package:startup_namer/data/push/betOffer_status_update.dart';
import 'package:startup_namer/store/action_type.dart';
import 'package:startup_namer/store/store.dart';
import 'package:startup_namer/util/flowable.dart';

class BetOfferStore implements Store {
  final Map<int, BehaviorSubject<BetOffer>> _betOffers = new HashMap();

  SnapshotObservable<BetOffer> operator [](id) {
    var subject = _betOffers[id];
    if (subject == null) {
      subject = new BehaviorSubject<BetOffer>();
      _betOffers[id] = subject;
    }
    return new SnapshotObservable(subject.value, subject.observable);
  }

  List<BetOffer> snapshot(List<int> ids) {
    return ids.map((id) => _betOffers[id])
        .where((subject) => subject != null)
        .map((subject) => subject.value)
        .toList(growable: false);
  }

  @override
  void dispatch(ActionType type, action) {
    switch (type) {
      case ActionType.eventResponse:
        EventResponse response = action;
        for (var betOffer in response.betoffers) {
          var subject = _betOffers[betOffer.id];
          if (subject != null) {
            if (subject.value != betOffer) {
              subject.add(betOffer);
            }
          } else {
            _betOffers[betOffer.id] = new BehaviorSubject<BetOffer>(seedValue: betOffer);
          }
        }
        break;
      case ActionType.betOfferStatusUpdate:
        BetOfferStatusUpdate update = action;
        var subject = _betOffers[update.betOfferId];
        if (subject != null && subject.value != null) {
          subject.add(subject.value.withSuspended(update.suspended));
        }
        break;
      default:
        break;
    }
  }

}