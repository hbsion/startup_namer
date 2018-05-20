import 'package:svan_play/data/betoffer.dart';
import 'package:svan_play/data/outcome.dart';

class BetOfferAdded {
  final BetOffer betOffer;
  final List<Outcome> outcomes;

  BetOfferAdded(this.betOffer, this.outcomes);

  BetOfferAdded.fromJson(Map<String, dynamic> json)
      : this(new BetOffer.fromJson(json["betOffer"]),
            json["betOffer"]["outcomes"].map<Outcome>((js) => new Outcome.fromJson(js)).toList());
}
