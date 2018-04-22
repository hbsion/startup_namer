import 'extended_info.dart';

class Participant {
  final int id; //participantId: number;
  final String name;
  final bool scratched;
  final bool nonRunner;
  final int startNumber;
  final ExtendedInfo extendedInfo;

  Participant({this.id, this.name, this.scratched, this.nonRunner, this.startNumber, this.extendedInfo});

  Participant.fromJson(Map<String, dynamic> json) : this (
    id: json["participantId"],
    name: json["name"],
    scratched: json["scratched"] ?? false,
    nonRunner: json["nonRunner"] ?? false,
    startNumber: json["startNumber"],
    extendedInfo: ExtendedInfo.fromJson(json["extendedInfo"])
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Participant &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              scratched == other.scratched &&
              nonRunner == other.nonRunner &&
              startNumber == other.startNumber &&
              extendedInfo == other.extendedInfo;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      scratched.hashCode ^
      nonRunner.hashCode ^
      startNumber.hashCode ^
      extendedInfo.hashCode;

  @override
  String toString() {
    return 'Participant{id: $id, name: $name, scratched: $scratched, nonRunner: $nonRunner, startNumber: $startNumber, extendedInfo: $extendedInfo}';
  }

}