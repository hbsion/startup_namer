import 'package:startup_namer/data/event_stats.dart';
import 'package:startup_namer/data/match_clock.dart';
import 'package:startup_namer/data/push/outcome_update.dart';
import 'package:startup_namer/data/score.dart';

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

