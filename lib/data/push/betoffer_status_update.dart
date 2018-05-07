
class BetOfferStatusUpdate {
  final int betOfferId;
  final bool suspended;

  BetOfferStatusUpdate({this.betOfferId, this.suspended});

  BetOfferStatusUpdate.fromJson(Map<String, dynamic> json) : this (
    betOfferId: json["betOfferId"],
    suspended: json["suspended"] ?? false
  );
}