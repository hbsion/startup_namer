import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/api/event_response.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/event_collection.dart';
import 'package:startup_namer/data/event_collection_key.dart';
import 'package:startup_namer/store/action_type.dart';
import 'package:startup_namer/store/store.dart';
import 'package:startup_namer/util/flowable.dart';
import 'package:startup_namer/util/func.dart';


class EventCollectionStore implements Store {
  final Map<EventCollectionKey, BehaviorSubject<EventCollection>> _collections = new HashMap();
  final Func<List<int>, List<Event>> eventResolver;

  EventCollectionStore(this.eventResolver);

  Flowable<EventCollection> collection(EventCollectionKey key) {

    print("collection query: " + key.toString() + " hash: " + key.hashCode.toString());
    var subject = _collections[key];
    if (subject == null) {
      subject = new BehaviorSubject<EventCollection>();
      _collections[key] = subject;
    }
    return new Flowable(subject);
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

        print("Event response: " + response.key.toString() + " hash: " + response.key.hashCode.toString());
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