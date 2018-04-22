import 'bet_offer_type.dart';
import 'criterion.dart';
import 'each_way.dart';
import 'pba.dart';

class BetOffer {
  final int id;
  final int eventId;
  final bool live;
  final Criterion criterion;
  final BetOfferType betOfferType;
  final Pba pba;
  final bool cashIn;
  final List<int> outcomes;
  final bool main;
  final bool prematch;
  final String cashOutStatus;
  final String categoryName;
  final bool suspended;
  final bool open;
  final String extra;
  final bool startingPrice;
  final EachWay eachWay;
  //     oddsStats: OddsStats;

  BetOffer({
    this.id,
    this.eventId,
    this.live,
    this.criterion,
    this.betOfferType,
    this.pba,
    this.cashIn,
    this.outcomes,
    this.main,
    this.prematch,
    this.cashOutStatus,
    this.categoryName,
    this.suspended,
    this.open,
    this.extra,
    this.startingPrice,
    this.eachWay
  });

  BetOffer.fromJson(Map<String, dynamic> json) : this (
    id: json["id"],
    eventId: json["eventId"],
    live: json["live"] ?? false,
    criterion: Criterion.fromJson(json["criterion"]),
    betOfferType: BetOfferType.fromJson(json["criterion"]),
    pba: Pba.fromJson(json["pba"]),
    cashIn: json["cashIn"],
    outcomes: ((json["outcomes"] ?? []) as List<Map<String, dynamic>>).map<int>((j) => j["id"]),
    main: json["main"] ?? false,
    prematch: json["prematch"] ?? false,
    cashOutStatus: json["cashOutStatus"],
    categoryName: json["categoryName"],
    suspended: json["suspended"] ?? false,
    open: json["open"] ?? false,
    extra: json["extra"],
    startingPrice: json["startingPrice"],
    eachWay: EachWay.fromJson(json["eachWay"]),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BetOffer &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              eventId == other.eventId &&
              live == other.live &&
              criterion == other.criterion &&
              betOfferType == other.betOfferType &&
              pba == other.pba &&
              cashIn == other.cashIn &&
              outcomes == other.outcomes &&
              main == other.main &&
              prematch == other.prematch &&
              cashOutStatus == other.cashOutStatus &&
              categoryName == other.categoryName &&
              suspended == other.suspended &&
              open == other.open &&
              extra == other.extra &&
              startingPrice == other.startingPrice &&
              eachWay == other.eachWay;

  @override
  int get hashCode =>
      id.hashCode ^
      eventId.hashCode ^
      live.hashCode ^
      criterion.hashCode ^
      betOfferType.hashCode ^
      pba.hashCode ^
      cashIn.hashCode ^
      outcomes.hashCode ^
      main.hashCode ^
      prematch.hashCode ^
      cashOutStatus.hashCode ^
      categoryName.hashCode ^
      suspended.hashCode ^
      open.hashCode ^
      extra.hashCode ^
      startingPrice.hashCode ^
      eachWay.hashCode;

  @override
  String toString() {
    return 'BetOffer{id: $id, eventId: $eventId, live: $live, criterion: $criterion, betOfferType: $betOfferType, pba: $pba, cashIn: $cashIn, outcomes: $outcomes, main: $main, prematch: $prematch, cashOutStatus: $cashOutStatus, categoryName: $categoryName, suspended: $suspended, open: $open, extra: $extra, startingPrice: $startingPrice, eachWay: $eachWay}';
  }


}