class Odds {
  final int decimal;
  final String fractional;
  final String american;

  Odds({this.decimal, this.fractional, this.american});

  Odds.fromJson(Map<String, dynamic> json) :
      this (
        decimal: json["odds"],
        fractional: json["oddsFractional"],
        american: json["oddsAmerican"],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Odds &&
              runtimeType == other.runtimeType &&
              decimal == other.decimal &&
              fractional == other.fractional &&
              american == other.american;

  @override
  int get hashCode =>
      decimal.hashCode ^
      fractional.hashCode ^
      american.hashCode;

  @override
  String toString() {
    return 'Odds{decimal: $decimal, fractional: $fractional, american: $american}';
  }

}