import 'package:startup_namer/data/football_stats.dart';
import 'package:startup_namer/data/set_stats.dart';
import 'package:startup_namer/data/team_stats.dart';

class EventStats {
  final SetStats sets;
  final FootballStats football;

  EventStats({this.sets, this.football});

  factory EventStats.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new EventStats(
        sets: new SetStats.fromJson(json["sets"]),
        football: new FootballStats.fromJson(json["football"]),
      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is EventStats &&
              runtimeType == other.runtimeType &&
              sets == other.sets &&
              football == other.football;

  @override
  int get hashCode =>
      sets.hashCode ^
      football.hashCode;

  @override
  String toString() {
    return 'EventStats{sets: $sets, football: $football}';
  }

}