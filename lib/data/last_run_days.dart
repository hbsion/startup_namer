class LastRunDays {
  final String type;
  final String days;

  LastRunDays({this.type, this.days});

  LastRunDays.fromJson(Map<String, dynamic> json) : this(
    type: json["type"],
    days: json["days"]
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LastRunDays &&
              runtimeType == other.runtimeType &&
              type == other.type &&
              days == other.days;

  @override
  int get hashCode =>
      type.hashCode ^
      days.hashCode;

  @override
  String toString() {
    return 'LastRunDays{type: $type, days: $days}';
  }
  
}