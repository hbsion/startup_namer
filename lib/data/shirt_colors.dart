class ShirtColors {
  final String shirtColor1;
  final String shirtColor2;

  ShirtColors({this.shirtColor1, this.shirtColor2});

  factory ShirtColors.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new ShirtColors(
        shirtColor1: json["shirtColor1"],
        shirtColor2: json["shirtColor2"],
      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ShirtColors &&
              runtimeType == other.runtimeType &&
              shirtColor1 == other.shirtColor1 &&
              shirtColor2 == other.shirtColor2;

  @override
  int get hashCode =>
      shirtColor1.hashCode ^
      shirtColor2.hashCode;

  @override
  String toString() {
    return 'ShirtColors{shirtColor1: $shirtColor1, shirtColor2: $shirtColor2}';
  }


}