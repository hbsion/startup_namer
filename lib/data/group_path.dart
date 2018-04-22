class GroupPath {
  final int id;
  final String name;
  final String termKey;

  GroupPath({this.id, this.name, this.termKey});

  factory GroupPath.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new GroupPath(
        id: json["id"],
        name: json["name"],
        termKey: json["termKey"],
      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GroupPath &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              termKey == other.termKey;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      termKey.hashCode;

  @override
  String toString() {
    return 'Path{id: $id, name: $name, termKey: $termKey}';
  }


}