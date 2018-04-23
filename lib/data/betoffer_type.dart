import 'package:meta/meta.dart';

class BetOfferType {
  final int id;
  final String name;

  BetOfferType({@required this.id, this.name});

  factory BetOfferType.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new BetOfferType(
          id: json["id"],
          name: json["name"]
      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BetOfferType &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode;

  @override
  String toString() {
    return 'BetOfferType{id: $id, name: $name}';
  }


}
