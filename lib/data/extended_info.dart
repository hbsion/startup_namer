import 'form_figures.dart';

class ExtendedInfo {
  final int startNumber;
  final String driverName;
  final String age;
  final String weight;
  final String editorial;
  final bool hasIcon;
  final String trainerName;
  final List<FormFigures> formFigures;

  ExtendedInfo({
    this.startNumber,
    this.driverName,
    this.age,
    this.weight,
    this.editorial,
    this.hasIcon,
    this.trainerName,
    this.formFigures
  });

  factory ExtendedInfo.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new ExtendedInfo(
          startNumber: json["startNumber"],
          driverName: json["driverName"],
          age: json["age"],
          weight: json["weight"],
          editorial: json["editorial"],
          trainerName: json["trainerName"],
          hasIcon: json["hasIcon"] ?? false,
          formFigures: ((json["formFigures"] ?? []) as List<Map<String, dynamic>>).map((j) => FormFigures.fromJson(j))

      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ExtendedInfo &&
              runtimeType == other.runtimeType &&
              startNumber == other.startNumber &&
              driverName == other.driverName &&
              age == other.age &&
              weight == other.weight &&
              editorial == other.editorial &&
              hasIcon == other.hasIcon &&
              trainerName == other.trainerName &&
              formFigures == other.formFigures;

  @override
  int get hashCode =>
      startNumber.hashCode ^
      driverName.hashCode ^
      age.hashCode ^
      weight.hashCode ^
      editorial.hashCode ^
      hasIcon.hashCode ^
      trainerName.hashCode ^
      formFigures.hashCode;

  @override
  String toString() {
    return 'ExtendedInfo{startNumber: $startNumber, driverName: $driverName, age: $age, weight: $weight, editorial: $editorial, hasIcon: $hasIcon, trainerName: $trainerName, formFigures: $formFigures}';
  }


}