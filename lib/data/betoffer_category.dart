import 'package:collection/collection.dart';
import 'package:svan_play/data/betoffer_category_mapping.dart';

class BetOfferCategory {
  final int id;
  final String name;
  final bool isDefault;
  final int sortOrder;
  final int boCount;
  final bool displayBoTypeHeaders;
  final String sport;
  final List<BetOfferCategoryMapping> mappings;

  BetOfferCategory(
      {this.id,
      this.name,
      this.isDefault,
      this.sortOrder,
      this.boCount,
      this.displayBoTypeHeaders,
      this.sport,
      this.mappings});

  BetOfferCategory.fromJson(Map<String, dynamic> json)
      : this(
          id: json["id"],
          name: json["name"],
          isDefault: json["isDefault"],
          sortOrder: json["sortOrder"],
          boCount: json["boCount"],
          sport: json["sport"],
          displayBoTypeHeaders: json["displayBoTypeHeaders"],
          mappings: ((json["mappings"] ?? []) as List<dynamic>)
              .map<BetOfferCategoryMapping>((js) => BetOfferCategoryMapping.fromJson(js))
              .toList(growable: false),
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BetOfferCategory &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          isDefault == other.isDefault &&
          sortOrder == other.sortOrder &&
          boCount == other.boCount &&
          displayBoTypeHeaders == other.displayBoTypeHeaders &&
          sport == other.sport &&
          const DeepCollectionEquality().equals(mappings, other.mappings);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      isDefault.hashCode ^
      sortOrder.hashCode ^
      boCount.hashCode ^
      displayBoTypeHeaders.hashCode ^
      sport.hashCode ^
      mappings.hashCode;

  BetOfferCategory withName(String name) {
    return new BetOfferCategory(
        id: id,
        name: name,
        sport: sport,
        boCount: boCount,
        displayBoTypeHeaders: displayBoTypeHeaders,
        mappings: mappings,
        isDefault: isDefault,
        sortOrder: sortOrder);
  }
}
