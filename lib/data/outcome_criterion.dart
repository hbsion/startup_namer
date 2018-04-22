
class OutcomeCriterion {
  final String type;
  final String name;

  OutcomeCriterion({this.type, this.name});

  factory OutcomeCriterion.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new OutcomeCriterion(
        type: json["type"],
        name: json["name"],
      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is OutcomeCriterion &&
              runtimeType == other.runtimeType &&
              type == other.type &&
              name == other.name;

  @override
  int get hashCode =>
      type.hashCode ^
      name.hashCode;

  @override
  String toString() {
    return 'OutcomeCriterion{type: $type, name: $name}';
  }


}