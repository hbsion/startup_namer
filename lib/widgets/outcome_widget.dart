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

  const OutcomeWidget({Key key, @required this.outcomeId})
      : assert(outcomeId != null),
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
              height: 38.0,
              padding: EdgeInsets.all(3.0),
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                color: Color.fromRGBO(0x00, 0xad, 0xc9, 1.0),
              ),
              child: new Material(
                color: Colors.transparent,
                child: new InkWell(
                    onTap: () => print("outcome tap " + DateTime.now().toString()),
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                            child: new Text(outcome.label, style: new TextStyle(color: Colors.white, fontSize: 12.0))),
                        new Text(
                            _formatOdds(outcome.odds, model.oddsFormat),
                            style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold))
                      ],
                    )),
              ));
        });
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
