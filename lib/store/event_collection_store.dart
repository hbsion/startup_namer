import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/api/event_response.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/event_collection.dart';
import 'package:startup_namer/data/event_collection_key.dart';
import 'package:startup_namer/store/action_type.dart';
import 'package:startup_namer/store/store.dart';


class EventCollectionStore implements Store {
  final Map<EventCollectionKey, BehaviorSubject<EventCollection>> _collections = new HashMap();

  Observable<EventCollection> collection(EventCollectionKey key) {
    var subject = _collections[key];
    if (subject == null) {
      subject = new BehaviorSubject<EventCollection>();
      _collections[key];
    }
    return subject.observable;
  }

  @override
  void dispatch(ActionType type, action) {
    switch (type) {
      case ActionType.EventResponse:
        EventResponse response = action;
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