import 'package:startup_namer/data/event_stats.dart';
import 'package:startup_namer/data/match_clock.dart';
import 'package:startup_namer/data/score.dart';

class LiveStats {
  final int eventId;
  final MatchClock matchClock;
  final Score score;
  final EventStats eventStats;

  LiveStats({this.eventId, this.matchClock, this.score, this.eventStats});

  factory LiveStats.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new LiveStats(
          eventId: json["eventId"],
          matchClock: new MatchClock.fromJson(json["matchClock"]),
          score: new Score.fromJson(json["score"]),
          eventStats: new EventStats.fromJson(json["statistics"])
      );
    }
    return null;
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LiveStats &&
              runtimeType == other.runtimeType &&
              eventId == other.eventId &&
              matchClock == other.matchClock &&
              score == other.score &&
              eventStats == other.eventStats;

  @override
  int get hashCode =>
      eventId.hashCode ^
      matchClock.hashCode ^
      score.hashCode ^
      eventStats.hashCode;

  @override
  String toString() {
    return 'LiveStats{eventId: $eventId, matchClock: $matchClock, score: $score, statistics: $eventStats}';
  }

}