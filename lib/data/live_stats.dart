import 'package:svan_play/data/event_stats.dart';
import 'package:svan_play/data/match_clock.dart';
import 'package:svan_play/data/match_occurence.dart';
import 'package:svan_play/data/score.dart';

class LiveStats {
  final int eventId;
  final MatchClock matchClock;
  final Score score;
  final EventStats eventStats;
  final List<MatchOccurence> occurences;

  LiveStats({this.eventId, this.matchClock, this.score, this.eventStats, this.occurences});

  factory LiveStats.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new LiveStats(
        eventId: json["eventId"],
        matchClock: new MatchClock.fromJson(json["matchClock"]),
        score: new Score.fromJson(json["score"]),
        eventStats: new EventStats.fromJson(json["statistics"]),
        occurences: json.containsKey("occurrences")
            ? ((json["occurrences"]) as List<dynamic>).map<MatchOccurence>((j) => MatchOccurence.fromJson(j)).toList()
            : null,
      );
    }
    return null;
  }
}
