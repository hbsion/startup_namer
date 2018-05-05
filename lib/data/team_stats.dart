class TeamStats {
  final int yellowCards;
  final int redCards;
  final int corners;

  TeamStats({this.yellowCards, this.redCards, this.corners});

  factory TeamStats.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new TeamStats(
        yellowCards: json["yellowCards"],
        redCards: json["redCards"],
        corners: json["corners"],
      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TeamStats &&
              runtimeType == other.runtimeType &&
              yellowCards == other.yellowCards &&
              redCards == other.redCards &&
              corners == other.corners;

  @override
  int get hashCode =>
      yellowCards.hashCode ^
      redCards.hashCode ^
      corners.hashCode;

  @override
  String toString() {
    return 'TeamStats{yellowCards: $yellowCards, redCards: $redCards, corners: $corners}';
  }

}