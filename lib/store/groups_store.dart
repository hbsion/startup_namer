import 'dart:collection';

import 'package:svan_play/data/event_group.dart';
import 'package:svan_play/store/action_type.dart';
import 'package:svan_play/store/store.dart';

typedef EventGroup EventGroupResolver(int id);

class GroupStore implements Store {
  final Map<int, EventGroup> _groups = new HashMap();
  final List<int> _highlights = [];

  EventGroup groupById(int id) {
    return _groups[id];
  }

  List<EventGroup> get sports {
    return _groups.values.where((eg) => eg.parent != null && eg.parent.isRoot).toList(growable: false);
  }

  List<EventGroup> get highlights {
    return _highlights.map((id) => _groups[id]).where((eg) => eg != null).toList(growable: false);
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
      case ActionType.highlightGroups:
        _highlights.clear();
        _highlights.addAll(action);
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