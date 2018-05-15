import 'package:svan_play/data/event_stats.dart';

class EventStatsUpdate {
  final int eventId;
  final EventStats eventStats;

  EventStatsUpdate({this.eventId, this.eventStats});

  EventStatsUpdate.fromJson(Map<String, dynamic> json) : this(
      eventId: json["eventId"],
      eventStats: new EventStats.fromJson(json["statistics"])
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is EventStatsUpdate &&
              runtimeType == other.runtimeType &&
              eventId == other.eventId &&
              eventStats == other.eventStats;

  @override
  int get hashCode =>
      eventId.hashCode ^
      eventStats.hashCode;

  @override
  String toString() {
    return 'EventStatsUpdate{eventId: $eventId, eventStats: $eventStats}';
  }
}

