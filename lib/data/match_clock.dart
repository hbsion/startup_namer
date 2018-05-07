class MatchClock {
  final int minute;
  final int second;
  final String period;
  final bool running;
  final bool disabled;

  MatchClock({this.minute, this.second, this.period, this.running, this.disabled});

  factory MatchClock.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new MatchClock(
        minute: json["minute"],
        second: json["second"],
        period: json["period"],
        running: json["running"] ?? false,
        disabled: json["disabled"] ?? false,
      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is MatchClock &&
              runtimeType == other.runtimeType &&
              minute == other.minute &&
              second == other.second &&
              period == other.period &&
              running == other.running &&
              disabled == other.disabled;

  @override
  int get hashCode =>
      minute.hashCode ^
      second.hashCode ^
      period.hashCode ^
      running.hashCode ^
      disabled.hashCode;

  @override
  String toString() {
    return 'MatchClock{minute: $minute, second: $second, period: $period, running: $running, disabled: $disabled}';
  }

}