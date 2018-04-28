import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:startup_namer/data/outcome.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/widgets/outcome_widget.dart';


class WinnerBetOfferWidget extends StatelessWidget {
  final int betOfferId;

  const WinnerBetOfferWidget({Key key, @required this.betOfferId})
      : assert(betOfferId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<List<Outcome>>(
        mapper: (store) => store.outcomeStore.byBetOfferId(betOfferId).observable,
        snapshot: (store) => store.outcomeStore.snapshotByBetOffer(betOfferId),
        widgetBuilder: _buildWidget
    );
  }

  Widget _buildWidget(BuildContext context, List<Outcome> model) {
    model.sort((a, b) => a.odds.decimal.compareTo(b.odds.decimal));
    return new Column(
        children: model.take(4).map((outcome) {
          return new Container(
              margin: const EdgeInsets.only(bottom: 4.0),
              child: new OutcomeWidget(outcomeId: outcome.id)
          );
        }).toList()
    );
  }

}