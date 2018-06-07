import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:svan_play/app_theme.dart';
import 'package:svan_play/data/betoffer.dart';
import 'package:svan_play/data/betoffer_tags.dart';
import 'package:svan_play/data/outcome.dart';
import 'package:svan_play/data/outcome_combination.dart';
import 'package:svan_play/data/outcome_status.dart';
import 'package:svan_play/models/main_model.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/util/odds_util.dart';

class OutcomeComboWidget extends StatelessWidget {
  final OutcomeCombination combo;
  final String label;

  const OutcomeComboWidget({Key key, @required this.combo, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return new StoreConnector<BetOffer>(
        initalData: (store) => store.betOfferStore[this.combo.resultOutcome.betOfferId].latest,
        stream: (store) => store.betOfferStore[this.combo.resultOutcome.betOfferId].observable,
        widgetBuilder: (context, betOffer) => _buildWidget(context, betOffer, model),
      );
    });
  }

  Widget _buildWidget(BuildContext context, BetOffer betOffer, MainModel model) {
    return new Container(
        height: 38.0,
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          color: AppTheme.of(context).outcome.background(disabled: _isSuspended(betOffer, combo.resultOutcome)),
        ),
        child: _buildContentWrapper(context, betOffer, model));
  }

  Widget _buildContentWrapper(BuildContext context, BetOffer betOffer, MainModel model) {
    if (_isSuspended(betOffer, combo.resultOutcome)) {
      return _buildContent(context, model);
    }

    return new Material(
      color: Colors.transparent,
      child: new InkWell(
          onTap: () => print("outcome tap " + DateTime.now().toString()), child: _buildContent(context, model)),
    );
  }

  Widget _buildContent(BuildContext context, MainModel model) {
    return new Container(
        alignment: Alignment.centerLeft,
        child: new Row(
          children: <Widget>[
            new Expanded(
                child: Text(
              label ?? combo.resultOutcome.label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white),
            )),
            Text(
              formatOdds(combo.odds, model.oddsFormat),
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ],
        ));
  }

  bool _isSuspended(BetOffer betOffer, Outcome outcome) =>
      betOffer.suspended ||
      outcome.status == OutcomeStatus.SUSPENDED ||
      (combo.odds.decimal == null && !betOffer.tags.contains(BetOfferTags.startingPrice));
}
