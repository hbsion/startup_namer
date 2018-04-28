import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:startup_namer/data/betoffer.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/widgets/outcome_widget.dart';

class MainBetOfferWidget extends StatelessWidget {
  final int betOfferId;

  const MainBetOfferWidget({Key key, @required this.betOfferId})
      : assert(betOfferId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<BetOffer>(
        mapper: (store) => store.betOfferStore[betOfferId].observable,
        snapshot: (store) => store.betOfferStore[betOfferId].last,
        widgetBuilder: _buildWidget
    );
  }

  Widget _buildWidget(BuildContext context, BetOffer model) {
    return new Row(children: _buildOutcomes(model.outcomes));
  }

  List<Widget> _buildOutcomes(List<int> outcomeIds) {
    List<Widget> widgets = [];
    if (outcomeIds != null) {
      for (var i = 0; i < outcomeIds.length; ++i) {
        var outcomeId = outcomeIds[i];
        if (i < (outcomeIds.length - 1)) {
          widgets.add(
              new Expanded(child: new Padding(padding: EdgeInsets.only(right: 4.0), child: new OutcomeWidget(outcomeId: outcomeId,))));
        } else {
          widgets.add(new Expanded(child: new OutcomeWidget(outcomeId: outcomeId,)));
        }
      }
    }
    return widgets;
  }
}
