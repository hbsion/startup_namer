import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:svan_play/data/betoffer.dart';
import 'package:svan_play/data/event_response.dart';
import 'package:svan_play/data/push/betOffer_status_update.dart';
import 'package:svan_play/data/push/betoffer_added.dart';
import 'package:svan_play/data/push/betoffer_removed.dart';
import 'package:svan_play/store/action_type.dart';
import 'package:svan_play/store/store.dart';
import 'package:svan_play/util/flowable.dart';

class BetOfferStore implements Store {
  final Map<int, BehaviorSubject<BetOffer>> _betOffers = new HashMap();
  final Map<int, BehaviorSubject<List<int>>> _betOffersByEvent = new HashMap();

  SnapshotObservable<BetOffer> operator [](int id) {
    var subject = _betOffers[id];
    if (subject == null) {
      subject = new BehaviorSubject<BetOffer>();
      _betOffers[id] = subject;
    }
    return new SnapshotObservable(subject.value, subject.stream);
  }

  SnapshotObservable<List<int>> byEventId(int id) {
    var subject = _betOffersByEvent[id];
    if (subject == null) {
      subject = new BehaviorSubject<List<int>>();
      _betOffersByEvent[id] = subject;
    }
    return new SnapshotObservable(subject.value, subject.stream);
  }

  List<BetOffer> snapshot(List<int> ids) {
    return ids
        .map((id) => _betOffers[id])
        .where((subject) => subject != null)
        .map((subject) => subject.value)
        .toList(growable: false);
  }

  @override
  void dispatch(ActionType type, action) {
    switch (type) {
      case ActionType.eventResponse:
        EventResponse response = action;
        _mergeBetOffers(response);
        break;
      case ActionType.betOfferResponse:
        EventResponse response = action;
        _mergeBetOffers(response);
        _mergeBetOffersByEvent(response);
        break;
      case ActionType.betOfferStatusUpdate:
        BetOfferStatusUpdate update = action;
        var subject = _betOffers[update.betOfferId];
        if (subject != null && subject.value != null) {
          subject.add(subject.value.withSuspended(update.suspended));
        }
        break;
      case ActionType.betOfferAdded:
        BetOfferAdded added = action;
        _mergeBetOffer(added.betOffer);
        break;
      case ActionType.betOfferRemoved:
        BetOfferRemoved removed = action;
        _removeBetOffer(removed.betOfferId);
        break;
      default:
        break;
    }
  }

  void _mergeBetOffer(BetOffer betOffer) {
    var subject = _betOffers[betOffer.id];
    if (subject != null) {
      subject.add(betOffer);
    } else {
      _betOffers[betOffer.id] = new BehaviorSubject<BetOffer>(seedValue: betOffer);
    }

    var betOffersByEventSubject = _betOffersByEvent[betOffer.eventId];
    if (betOffersByEventSubject != null && betOffersByEventSubject.value != null) {
      List<int> ids = betOffersByEventSubject.value;
      betOffersByEventSubject.add(new List.from(ids)..add(betOffer.id));
    }
  }

  void _removeBetOffer(int betOfferId) {
    var subject = _betOffers[betOfferId];
    if (subject != null) {
      var betOffer = subject.value;

      subject.add(null);
      subject.close();
      _betOffers.remove(betOfferId);

      if (betOffer != null) {
        var betOffersByEventSubject = _betOffersByEvent[betOffer.eventId];
        if (betOffersByEventSubject != null && betOffersByEventSubject.value != null) {
          List<int> ids = betOffersByEventSubject.value;
          betOffersByEventSubject.add(new List.from(ids)..remove(betOffer.id));
        }
      }
    }
  }

  void _mergeBetOffers(EventResponse response) {
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
  }

  void _mergeBetOffersByEvent(EventResponse response) {
    Map<int, List<BetOffer>> betOffersByEvent = groupBy(response.betoffers, (bo) => bo.eventId);
    betOffersByEvent.forEach((eventId, betOffers) {
      var ids = betOffers.map((bo) => bo.id).toList()..sort();
      var subject = _betOffersByEvent[eventId];
      if (subject != null) {
        if (!ListEquality().equals(subject.value, ids)) {
          subject.add(ids);
        }
      } else {
        _betOffersByEvent[eventId] = new BehaviorSubject<List<int>>(seedValue: ids);
      }
    });
  }
}
