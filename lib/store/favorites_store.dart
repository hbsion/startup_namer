import 'dart:collection';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:svan_play/store/action_type.dart';
import 'package:svan_play/store/store.dart';
import 'package:svan_play/util/flowable.dart';

class FavoritesStore implements Store {
  final BehaviorSubject<Set<int>> _favorites = new BehaviorSubject<Set<int>>(seedValue: new HashSet());

  SnapshotObservable<Set<int>> favorites() {
    return new SnapshotObservable(_favorites.value, _favorites.stream);
  }

  Set<int> snapshot() {
    return _favorites.value;
  }

  @override
  void dispatch(ActionType type, action) {
    base64.decode("");
    switch (type) {
      case ActionType.toggleFavorite:
        int eventId = action;
        Set<int> favorites = new HashSet();
        favorites.addAll(snapshot());
        if (favorites.contains(eventId)) {
          favorites.remove(eventId);
        } else {
          favorites.add(eventId);
        }
        _favorites.add(favorites);
        break;
      default:
        break;
    }
  }

}