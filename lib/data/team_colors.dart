import 'shirt_colors.dart';

class TeamColors {
  final ShirtColors home;
  final ShirtColors away;

  TeamColors({this.home, this.away});

  factory TeamColors.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new TeamColors(
        home: ShirtColors.fromJson(json["home"]),
        away: ShirtColors.fromJson(json["away"]),
      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TeamColors &&
              runtimeType == other.runtimeType &&
              home == other.home &&
              away == other.away;

  @override
  int get hashCode =>
      home.hashCode ^
      away.hashCode;

  @override
  String toString() {
    return 'TeamColors{home: $home, away: $away}';
  }
}