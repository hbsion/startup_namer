import 'package:collection/collection.dart';

class EventGroup {
  final int id;
  final String name;
  final int boCount;
  final int eventCount;
  final List<EventGroup> groups;
  final String sport;
  final String termKey;
  final int sortOrder;
  EventGroup _parent;

  EventGroup(
      {this.id, this.name, this.boCount, this.eventCount, this.groups, this.sport, this.termKey, this.sortOrder, EventGroup parent})
      : this._parent = parent;

  factory EventGroup.fromJson(Map<String, dynamic> json, {EventGroup parent}) {
    var eventGroup = new EventGroup(
      id: json["id"],
      name: json["name"],
      boCount: json["boCount"] ?? 0,
      eventCount: json["eventCount"] ?? 0,
      sport: json["sport"],
      termKey: json["termKey"],
      sortOrder: int.parse(json["sortOrder"] ?? "100"),
      parent: parent,
      groups: (
          (
              json["groups"] ?? []) as List<dynamic>).map<EventGroup>((j) => EventGroup.fromJson(j)).toList(),
    );
    eventGroup.groups.forEach((eg) => eg._parent = eventGroup);

    return eventGroup;
  }

  EventGroup get parent => _parent;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is EventGroup &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              boCount == other.boCount &&
              eventCount == other.eventCount &&
              new ListEquality().equals(groups, other.groups) &&
              sport == other.sport &&
              termKey == other.termKey &&
              sortOrder == other.sortOrder;

  @override
  int get hashCode => id.hashCode;

  static EventGroup resolveRoot(EventGroup group) {
    if (group.parent == null || group.parent.id == 1)
      return group;

    return resolveRoot(group.parent);
  }
}