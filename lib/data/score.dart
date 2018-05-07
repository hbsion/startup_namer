
class Score {
  final String home;
  final String away;
  final String info;
  final String who;

  Score({this.home, this.away, this.info, this.who});

  factory Score.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new Score(
          home: json["home"],
          away: json["away"],
          info: json["info"],
          who: json["who"],
      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Score &&
              runtimeType == other.runtimeType &&
              home == other.home &&
              away == other.away &&
              info == other.info &&
              who == other.who;

  @override
  int get hashCode =>
      home.hashCode ^
      away.hashCode ^
      info.hashCode ^
      who.hashCode;

  @override
  String toString() {
    return 'Score{home: $home, away: $away, info: $info, who: $who}';
  }

}