import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/api/event_response.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/event_group.dart';
import 'package:startup_namer/store/action_type.dart';
import 'package:startup_namer/store/store.dart';
import 'package:startup_namer/util/flowable.dart';

class GroupStore implements Store {
  final Map<int, EventGroup> _groups = new HashMap();

  EventGroup groupById(int id) {
    return _groups[id];
  }

  @override
  void dispatch(ActionType type, action) {
    switch (type) {
      case ActionType.eventGroups:
        EventGroup root = action;
        if (root != null) {
          _groups.clear();
          _addAllGroups(root.groups);
        }
        break;
      default:
        break;
    }
  }

  void _addAllGroups(List<EventGroup> groups) {
    for (var group in groups) {
      _groups[group.id] = group;
      _addAllGroups(group.groups);
    }
  }

}