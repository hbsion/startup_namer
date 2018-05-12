class ResultTerm {
  final String type;
  final String id;
  final String termKey;
  final String localizedName;
  final String parentId;
  final String value;

  ResultTerm({this.type, this.id, this.termKey, this.localizedName, this.parentId, this.value});

  ResultTerm.fromJson(Map<String, dynamic> json) :
      this(
        type: json["type"],
        id: json["id"],
        termKey: json["termKey"],
        localizedName: json["localizedName"],
        parentId: json["parentId"],
        value: json["value"],
      );

  @override
  String toString() {
    return 'ResultTerm{type: $type, id: $id, termKey: $termKey, localizedName: $localizedName, parentId: $parentId, value: $value}';
  }

}
