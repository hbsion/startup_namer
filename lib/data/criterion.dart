import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

class Criterion {
  final int id;
  final String label;
  final List<int> order;

  Criterion({@required this.id, this.label, this.order});

  factory Criterion.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return Criterion(
          id: json["id"],
          label: json["label"],
          order: ((json["order"] ?? []) as List<dynamic>).map<int>((i) => i).toList(growable: false)
      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Criterion &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              label == other.label &&
              const ListEquality().equals(order, other.order);

  @override
  int get hashCode =>
      id.hashCode ^
      label.hashCode ^
      order.hashCode;

  @override
  String toString() {
    return 'Criterion{id: $id, label: $label, order: $order}';
  }


}