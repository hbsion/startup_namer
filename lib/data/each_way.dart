class EachWay {
  final String terms;
  final int fractionMilli;
  final int placeLimit;
  final List<String> tags;

  EachWay({this.terms, this.fractionMilli, this.placeLimit, this.tags});

  factory EachWay.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new EachWay(
          terms: json["terms"] ?? [],
          fractionMilli: json["fractionMilli"],
          placeLimit: json["placeLimit"],
          tags: json["tags"] ?? []
      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is EachWay &&
              runtimeType == other.runtimeType &&
              terms == other.terms &&
              fractionMilli == other.fractionMilli &&
              placeLimit == other.placeLimit &&
              tags == other.tags;

  @override
  int get hashCode =>
      terms.hashCode ^
      fractionMilli.hashCode ^
      placeLimit.hashCode ^
      tags.hashCode;

  @override
  String toString() {
    return 'EachWay{terms: $terms, fractionMilli: $fractionMilli, placeLimit: $placeLimit, tags: $tags}';
  }

}