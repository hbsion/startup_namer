import 'package:svan_play/data/betoffer.dart';

class BetOfferAdded {
  final BetOffer betOffer;

  BetOfferAdded(this.betOffer);

  BetOfferAdded.fromJson(Map<String, dynamic> json) : this (
    new BetOffer.fromJson(json["betOffer"])
  );
}