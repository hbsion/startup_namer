class Pba {
  final bool disabled;
  final String status;

  Pba({this.disabled, this.status});

  factory Pba.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new Pba(
        disabled: json["disabled"] ?? false,
        status: json["status"]
      );
    }

    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Pba &&
              runtimeType == other.runtimeType &&
              disabled == other.disabled &&
              status == other.status;

  @override
  int get hashCode =>
      disabled.hashCode ^
      status.hashCode;

  @override
  String toString() {
    return 'Pba{disabled: $disabled, status: $status}';
  }


}