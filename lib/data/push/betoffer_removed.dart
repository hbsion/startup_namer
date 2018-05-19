import 'package:svan_play/data/betoffer.dart';

class BetOfferRemoved {
  final int betOfferId;

  BetOfferRemoved(this.betOfferId);

  BetOfferRemoved.fromJson(Map<String, dynamic> json) : this (
    json["betOfferId"]
  );
}
