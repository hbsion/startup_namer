class FormFigures {
  final String type;
  final String figures;

  FormFigures({this.type, this.figures});

  FormFigures.fromJson(Map<String, dynamic> json) : this(
    type: json["type"],
    figures: json["figures"]
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FormFigures &&
              runtimeType == other.runtimeType &&
              type == other.type &&
              figures == other.figures;

  @override
  int get hashCode =>
      type.hashCode ^
      figures.hashCode;

  @override
  String toString() {
    return 'FormFigures{type: $type, figures: $figures}';
  }
  
}