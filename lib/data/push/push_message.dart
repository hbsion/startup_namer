import 'package:meta/meta.dart';
import 'package:svan_play/data/push/betOffer_status_update.dart';
import 'package:svan_play/data/push/betoffer_added.dart';
import 'package:svan_play/data/push/betoffer_removed.dart';
import 'package:svan_play/data/push/event_stats_update.dart';
import 'package:svan_play/data/push/match_clock_update.dart';
import 'package:svan_play/data/push/odds_update.dart';
import 'package:svan_play/data/push/push_message_type.dart';
import 'package:svan_play/data/push/score_update.dart';

class PushMessage {
  final PushMessageType type;
  final OddsUpdate oddsUpdate;
  final MatchClockUpdate matchClockUpdate;
  final ScoreUpdate scoreUpdate;
  final EventStatsUpdate eventStatsUpdate;
  final BetOfferStatusUpdate betOfferStatusUpdate;
  final BetOfferAdded betOfferAdded;
  final BetOfferRemoved betOfferRemoved;

  PushMessage({
    @required this.type,
    this.oddsUpdate,
    this.matchClockUpdate,
    this.scoreUpdate,
    this.eventStatsUpdate,
    this.betOfferStatusUpdate,
    this.betOfferAdded,
    this.betOfferRemoved
  });

  factory PushMessage.fromJson(Map<String, dynamic> json) {
    PushMessageType type = toPushMessageType(json["mt"]);
    switch (type) {
      case PushMessageType.betOfferAdded:
        return new PushMessage(type: type, betOfferAdded: new BetOfferAdded.fromJson(json["boa"]));
      case PushMessageType.betOfferRemoved:
        return new PushMessage(type: type, betOfferRemoved: new BetOfferRemoved.fromJson(json["bor"]));
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