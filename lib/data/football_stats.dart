import 'package:svan_play/data/team_stats.dart';

class FootballStats {
  final TeamStats home;
  final TeamStats away;

  FootballStats({this.home, this.away});

  factory FootballStats.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new FootballStats(
        home: new TeamStats.fromJson(json["home"]),
        away: new TeamStats.fromJson(json["away"]),
      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FootballStats &&
              runtimeType == other.runtimeType &&
              home == other.home &&
              away == other.away;

  @override
  int get hashCode =>
      home.hashCode ^
      away.hashCode;

  @override
  String toString() {
    return 'FootballStats{home: $home, away: $away}';
  }

}