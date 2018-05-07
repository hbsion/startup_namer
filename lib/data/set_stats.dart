class SetStats {
  final List<int> home;
  final List<int> away;
  final bool homeServe;

  SetStats({this.home, this.away, this.homeServe});

  factory SetStats.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new SetStats(
        home: ((json["home"] ?? []) as List<dynamic>).map<int>((i) => i).toList(growable: false),
        away: ((json["away"] ?? []) as List<dynamic>).map<int>((i) => i).toList(growable: false),
        homeServe: json["homeServe"] ?? false,
      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SetStats &&
              runtimeType == other.runtimeType &&
              home == other.home &&
              away == other.away &&
              homeServe == other.homeServe;

  @override
  int get hashCode =>
      home.hashCode ^
      away.hashCode ^
      homeServe.hashCode;

  @override
  String toString() {
    return 'TeamStats{home: $home, away: $away, homeServe: $homeServe}';
  }

}