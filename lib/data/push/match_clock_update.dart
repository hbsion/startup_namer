import 'package:startup_namer/data/match_clock.dart';
import 'package:startup_namer/data/push/outcome_update.dart';

class MatchClockUpdate {
  final int eventId;
  final MatchClock matchClock;

  MatchClockUpdate({this.eventId, this.matchClock});

  MatchClockUpdate.fromJson(Map<String, dynamic> json) : this(
      eventId: json["eventId"],
      matchClock: new MatchClock.fromJson(json["matchClock"])
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MatchClockUpdate &&
              runtimeType == other.runtimeType &&
              eventId == other.eventId &&
              matchClock == other.matchClock;

  @override
  int get hashCode =>
      eventId.hashCode ^
      matchClock.hashCode;

  @override
  String toString() {
    return 'MatchClockUpdate{eventId: $eventId, matchClock: $matchClock}';
  }

}

