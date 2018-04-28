import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/api/event_response.dart';
import 'package:startup_namer/data/betoffer.dart';
import 'package:startup_namer/data/event.dart';
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
      case ActionType.EventResponse:
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

      default:
        break;
    }
  }

}