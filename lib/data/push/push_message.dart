import 'package:meta/meta.dart';
import 'package:startup_namer/data/push/betOffer_status_update.dart';
import 'package:startup_namer/data/push/event_stats_update.dart';
import 'package:startup_namer/data/push/match_clock_update.dart';
import 'package:startup_namer/data/push/odds_update.dart';
import 'package:startup_namer/data/push/push_message_type.dart';
import 'package:startup_namer/data/push/score_update.dart';

class PushMessage {
  final PushMessageType type;
  final OddsUpdate oddsUpdate;
  final MatchClockUpdate matchClockUpdate;
  final ScoreUpdate scoreUpdate;
  final EventStatsUpdate eventStatsUpdate;
  final BetOfferStatusUpdate betOfferStatusUpdate;

  PushMessage({
    @required this.type,
    this.oddsUpdate,
    this.matchClockUpdate,
    this.scoreUpdate,
    this.eventStatsUpdate,
    this.betOfferStatusUpdate
  });

  factory PushMessage.fromJson(Map<String, dynamic> json) {
    PushMessageType type = toPushMessageType(json["mt"]);
    switch (type) {
      case PushMessageType.betOfferStatusUpdate:
        return new PushMessage(type: type, betOfferStatusUpdate: new BetOfferStatusUpdate.fromJson(json["bosu"]));
      case PushMessageType.oddsUpdate:
        return new PushMessage(type: type, oddsUpdate: new OddsUpdate.fromJson(json["boou"]));
      case PushMessageType.matchClockUpdate:
        return new PushMessage(type: type, matchClockUpdate: new MatchClockUpdate.fromJson(json["mcu"]));
      case PushMessageType.scoreUpdate:
        return new PushMessage(type: type, scoreUpdate: new ScoreUpdate.fromJson(json["score"]));
      case PushMessageType.eventStatsUpdate:
        return new PushMessage(type: type, eventStatsUpdate: new EventStatsUpdate.fromJson(json["stats"]));
      case PushMessageType.unknown:
      default:
        return null;
    }
  }

  @override
  String toString() {
    return 'PushMessage{type: $type, oddsUpdate: $oddsUpdate}';
  }

}