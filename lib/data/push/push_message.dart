import 'package:startup_namer/data/push/odds_update.dart';
import 'package:startup_namer/data/push/push_message_type.dart';

class PushMessage {
  final PushMessageType type;
  final OddsUpdate oddsUpdate;

  PushMessage(this.type, this.oddsUpdate);

  factory PushMessage.fromJson(Map<String, dynamic> json) {
    PushMessageType type = toPushMessageType(json["mt"]);
    switch (type) {
      case PushMessageType.oddsUpdate:
        return new PushMessage(type, OddsUpdate.fromJson(json["boou"]));
      case PushMessageType.unknown:
      default:
        return null;
    }
  }
}