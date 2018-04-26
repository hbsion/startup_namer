import 'package:collection/collection.dart';

import 'betoffer_type.dart';
import 'cashout_status.dart';
import 'criterion.dart';
import 'each_way.dart';
import 'outcome_criterion.dart';

class BetOffer {
  final int id;
  final bool suspended;
  final DateTime closed;
  final Criterion criterion;
  final String extra;
  final BetOfferType betOfferType;
  final int placeLimit;
  final int eventId;
  final List<int> outcomes;
  final bool place;
  final EachWay eachWay;
  final OutcomeCriterion scorerType;
  final List<String> tags;
  final CashoutStatus cashOutStatus;
  final int sortOrder;
  final int from;
  final int to;
  final String description;

  //     oddsStats: OddsStats;
  // combinableOutcomes


  BetOffer({
    this.id,
    this.eventId,
    this.criterion,
    this.betOfferType,
    this.outcomes,
    this.cashOutStatus,
    this.suspended,
    this.extra,
    this.eachWay,
    this.closed,
    this.placeLimit,
    this.place,
    this.scorerType,
    this.tags,
    this.sortOrder,
    this.from,
    this.to,
    this.description,
  });

  BetOffer.fromJson(Map<String, dynamic> json) : this (
    id: json["id"],
    suspended: json["suspended"] ?? false,
    closed: json["closed"] != null ? DateTime.parse(json["closed"]) : null,
    criterion: Criterion.fromJson(json["criterion"]),
    extra: json["extra"],
    betOfferType: BetOfferType.fromJson(json["betOfferType"]),
    placeLimit: json["placeLimit"],
    eventId: json["eventId"],
    outcomes: ((json["outcomes"] ?? []) as List<dynamic>).map<int>((j) => j["id"]).toList(growable: false),
    tags: ((json["tags"] ?? []) as List<dynamic>).map<String>((j) => j).toList(growable: false),
    place: json["place"] ?? false,
    eachWay: EachWay.fromJson(json["eachWay"]),
    scorerType: OutcomeCriterion.fromJson(json["scorerType"]),
    cashOutStatus: toCashoutStatue(json["cashOutStatus"]),
    sortOrder: json["sortOrder"],
    from: json["from"],
    to: json["to"],
    description: json["description"],
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
          other is BetOffer &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              suspended == other.suspended &&
              closed == other.closed &&
              criterion == other.criterion &&
              extra == other.extra &&
              betOfferType == other.betOfferType &&
              placeLimit == other.placeLimit &&
              eventId == other.eventId &&
              const ListEquality().equals(outcomes, other.outcomes)  &&
              place == other.place &&
              eachWay == other.eachWay &&
              scorerType == other.scorerType &&
              const ListEquality().equals(tags, other.tags)  &&
              cashOutStatus == other.cashOutStatus &&
              sortOrder == other.sortOrder &&
              from == other.from &&
              to == other.to &&
              description == other.description;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      suspended.hashCode ^
      closed.hashCode ^
      criterion.hashCode ^
      extra.hashCode ^
      betOfferType.hashCode ^
      placeLimit.hashCode ^
      eventId.hashCode ^
      outcomes.hashCode ^
      place.hashCode ^
      eachWay.hashCode ^
      scorerType.hashCode ^
      tags.hashCode ^
      cashOutStatus.hashCode ^
      sortOrder.hashCode ^
      from.hashCode ^
      to.hashCode ^
      description.hashCode;

  @override
  String toString() {
    return 'BetOffer{id: $id, suspended: $suspended, closed: $closed, criterion: $criterion, extra: $extra, betOfferType: $betOfferType, placeLimit: $placeLimit, eventId: $eventId, outcomes: $outcomes, place: $place, eachWay: $eachWay, scorerType: $scorerType, tags: $tags, cashOutStatus: $cashOutStatus, sortOrder: $sortOrder, from: $from, to: $to, description: $description}';
  }


}