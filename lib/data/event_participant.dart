import 'extended_info.dart';

class EventParticipant {
  final int id; //participantId: number;
  final String name;
  final bool scratched;
  final bool nonRunner;
  final int startNumber;
  final ExtendedInfo extended;

  EventParticipant({this.id, this.name, this.scratched, this.nonRunner, this.startNumber, this.extended});

  EventParticipant.fromJson(Map<String, dynamic> json) : this (
    id: json["participantId"],
    name: json["name"],
    scratched: json["scratched"] ?? false,
    nonRunner: json["nonRunner"] ?? false,
    startNumber: json["startNumber"],
    extended: ExtendedInfo.fromJson(json["extended"])
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is EventParticipant &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              scratched == other.scratched &&
              nonRunner == other.nonRunner &&
              startNumber == other.startNumber &&
              extended == other.extended;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      scratched.hashCode ^
      nonRunner.hashCode ^
      startNumber.hashCode ^
      extended.hashCode;

  @override
  String toString() {
    return 'Participant{id: $id, name: $name, scratched: $scratched, nonRunner: $nonRunner, startNumber: $startNumber, extendedInfo: $extended}';
  }

}