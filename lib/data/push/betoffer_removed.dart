

class BetOfferRemoved {
  final int betOfferId;

  BetOfferRemoved(this.betOfferId);

  BetOfferRemoved.fromJson(Map<String, dynamic> json) : this (
    json["betOfferId"]
  );
}
