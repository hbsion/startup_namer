import 'package:svan_play/data/odds.dart';

class OutcomeUpdate {
  final int id;
  final int betOfferId;
  final Odds odds;

  OutcomeUpdate({this.id, this.betOfferId, this.odds});

  OutcomeUpdate.fromJson(Map<String, dynamic> json) : this(
    id: json["id"],
    betOfferId: json["betOfferId"],
    odds: new Odds.fromJson(json),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is OutcomeUpdate &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              betOfferId == other.betOfferId &&
              odds == other.odds;

  @override
  int get hashCode =>
      id.hashCode ^
      betOfferId.hashCode ^
      odds.hashCode;

  @override
  String toString() {
    return 'OddsUpdated{outcomeId: $id, betOfferId: $betOfferId, odds: $odds}';
  }

}