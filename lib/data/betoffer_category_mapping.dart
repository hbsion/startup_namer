class BetOfferCategoryMapping {
  final int criterionId;
  final int boType;
  final int sortOrder;

  BetOfferCategoryMapping({this.criterionId, this.boType, this.sortOrder});

  BetOfferCategoryMapping.fromJson(Map<String, dynamic> json)
      : this(
          criterionId: json["criterionId"],
          boType: json["boType"],
          sortOrder: json["sortOrder"],
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BetOfferCategoryMapping &&
              runtimeType == other.runtimeType &&
              criterionId == other.criterionId &&
              boType == other.boType &&
              sortOrder == other.sortOrder;

  @override
  int get hashCode =>
      criterionId.hashCode ^
      boType.hashCode ^
      sortOrder.hashCode;
  


}
