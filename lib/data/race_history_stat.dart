class RaceHistoryStat {
  final String type;
  final String stat;

  RaceHistoryStat({this.type, this.stat});

  RaceHistoryStat.fromJson(Map<String, dynamic> json) : this(
    type: json["type"],
    stat: json["stat"]
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RaceHistoryStat &&
              runtimeType == other.runtimeType &&
              type == other.type &&
              stat == other.stat;

  @override
  int get hashCode =>
      type.hashCode ^
      stat.hashCode;

  @override
  String toString() {
    return 'RaceHistoryStat{type: $type, stat: $stat}';
  }
  
}