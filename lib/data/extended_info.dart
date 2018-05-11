import 'package:collection/collection.dart';
import 'package:startup_namer/data/last_run_days.dart';
import 'package:startup_namer/data/race_history_stat.dart';

import 'form_figures.dart';

class ExtendedInfo {
  final int startNumber;
  final String driverName;
  final String age;
  final String weight;
  final String editorial;
  final bool hasIcon;
  final String icon;
  final String trainerName;
  final List<FormFigures> formFigures;
  final List<LastRunDays> lastRunDays;
  final List<RaceHistoryStat> raceHistoryStat;

  ExtendedInfo({
    this.startNumber,
    this.driverName,
    this.age,
    this.weight,
    this.editorial,
    this.hasIcon,
    this.icon,
    this.trainerName,
    this.formFigures,
    this.lastRunDays,
    this.raceHistoryStat,
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
          icon: json["icon"],
          hasIcon: json["hasIcon"] ?? false,
          formFigures: ((json["formFigures"] ?? []) as List<dynamic>).map<FormFigures>((j) => FormFigures.fromJson(j)).toList(),
          lastRunDays: ((json["lastRunDays"] ?? []) as List<dynamic>).map<LastRunDays>((j) => LastRunDays.fromJson(j)).toList(),
          raceHistoryStat: ((json["raceHistoryStat"] ?? []) as List<dynamic>).map<RaceHistoryStat>((j) => RaceHistoryStat.fromJson(j)).toList()
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
              const DeepCollectionEquality().equals(formFigures, other.formFigures) &&
              const DeepCollectionEquality().equals(lastRunDays, other.lastRunDays) &&
              const DeepCollectionEquality().equals(raceHistoryStat, other.raceHistoryStat);

  @override
  int get hashCode =>
      startNumber.hashCode ^
      driverName.hashCode ^
      age.hashCode ^
      weight.hashCode ^
      editorial.hashCode ^
      hasIcon.hashCode ^
      trainerName.hashCode ^
      formFigures.hashCode ^
      lastRunDays.hashCode ^
      raceHistoryStat.hashCode;

  @override
  String toString() {
    return 'ExtendedInfo{startNumber: $startNumber, driverName: $driverName, age: $age, weight: $weight, editorial: $editorial, hasIcon: $hasIcon, trainerName: $trainerName, formFigures: $formFigures, lastRunDays: $lastRunDays, raceHistoryStat: $raceHistoryStat}';
  }


}