import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:svan_play/data/event_response.dart';
import 'package:svan_play/data/event_collection.dart';
import 'package:svan_play/data/event_collection_key.dart';
import 'package:svan_play/store/action_type.dart';
import 'package:svan_play/store/store.dart';
import 'package:svan_play/util/flowable.dart';


class EventCollectionStore implements Store {
  final Map<EventCollectionKey, BehaviorSubject<EventCollection>> _collections = new HashMap();

  SnapshotObservable<EventCollection> operator [](EventCollectionKey key) {
    var subject = _collections[key];
    if (subject == null) {
      subject = new BehaviorSubject<EventCollection>();
      _collections[key] = subject;
    }
    return new SnapshotObservable(subject.value, subject.stream);
  }


  @override
  void dispatch(ActionType type, action) {
    switch (type) {
      case ActionType.eventResponse:
        EventResponse response = action;
        if (response.key.type == EventCollectionType.eventView) {
          return;
        }
        
        EventCollection collection = new EventCollection(
            key: response.key,
            eventIds: response.events.map((e)=> e.id).toList()
        );
        collection.eventIds.sort((a,b) => a.compareTo(b));

        var subject = _collections[response.key];
        if (subject != null) {
          if (subject.value != collection) {
            subject.add(collection);
          }
        } else {
          _collections[response.key] = new BehaviorSubject<EventCollection>(seedValue: collection);
        }
        break;

      default:
        break;
    }
  }

}