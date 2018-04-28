import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:startup_namer/data/odds.dart';
import 'package:startup_namer/data/outcome.dart';
import 'package:startup_namer/models/main_model.dart';
import 'package:startup_namer/models/odds_format.dart';
import 'package:startup_namer/store/store_connector.dart';

class OutcomeWidget extends StatelessWidget {
  final int outcomeId;
  final bool columnLayout;

  const OutcomeWidget({Key key, @required this.outcomeId, this.columnLayout = false})
      : assert(outcomeId != null),
        assert(columnLayout != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<Outcome>(
        mapper: (store) => store.outcomeStore[outcomeId].observable,
        snapshot: (store) => store.outcomeStore[outcomeId].last,
        widgetBuilder: _buildWidget
    );
  }

  Widget _buildWidget(BuildContext context, Outcome outcome) {
    return new ScopedModelDescendant<MainModel>(
        builder: (context, child, model) {
          return new Container(
              height: columnLayout ? 48.0 : 38.0,
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                color: Color.fromRGBO(0x00, 0xad, 0xc9, 1.0),
              ),
              child: new Material(
                color: Colors.transparent,
                child: new InkWell(
                    onTap: () => print("outcome tap " + DateTime.now().toString()),
                    child: _buildContent(outcome, model)),
              ));
        });
  }

  Widget _buildContent(Outcome outcome, MainModel model) {
    if (columnLayout) {
      return new Column(
        children: <Widget>[
          new Expanded(child: new Center(child: _buildLabel(outcome))),
          new Expanded(child: new Center(child: _buildOdds(outcome, model)))
        ],
      );
    }

    return new Row(
      children: <Widget>[
        new Expanded(child: _buildLabel(outcome)),
        _buildOdds(outcome, model)
      ],
    );
  }

  Text _buildOdds(Outcome outcome, MainModel model) {
    return new Text(
        _formatOdds(outcome.odds, model.oddsFormat),
        style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold));
  }

  Text _buildLabel(Outcome outcome) {
    return new Text(
        outcome.label ?? "?", style: new TextStyle(color: Colors.white, fontSize: 12.0));
  }


  String _formatOdds(Odds odds, OddsFormat format) {
    switch (format) {
      case OddsFormat.Fractional:
        return odds.fractional ?? "";
      case OddsFormat.American:
        return odds.american ?? "";
      case OddsFormat.Decimal:
      default:
        return ((odds.decimal ?? 1000) / 1000).toString();
    }
  }
}
