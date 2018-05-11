import 'dart:typed_data';

class SilkImage {
  final int eventId;
  final int participantId;
  final Uint8List image;

  SilkImage(this.eventId, this.participantId, this.image);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SilkImage &&
              runtimeType == other.runtimeType &&
              eventId == other.eventId &&
              image == other.image;

  @override
  int get hashCode =>
      eventId.hashCode ^
      image.hashCode;

  @override
  String toString() {
    return 'SilkImage{eventId: $eventId, participantId: $participantId, image: $image}';
  }
}