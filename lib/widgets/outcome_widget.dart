import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:startup_namer/data/betoffer.dart';
import 'package:startup_namer/data/betoffer_types.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/odds.dart';
import 'package:startup_namer/data/outcome.dart';
import 'package:startup_namer/data/outcome_type.dart';
import 'package:startup_namer/models/main_model.dart';
import 'package:startup_namer/models/odds_format.dart';
import 'package:startup_namer/store/app_store.dart';
import 'package:startup_namer/store/store_connector.dart';

class OutcomeWidget extends StatelessWidget {
  final int outcomeId;
  final int betOfferId;
  final int eventId;
  final bool columnLayout;
  final bool overrideShowLabel;

  const OutcomeWidget(
      {Key key, @required this.outcomeId, @required this.betOfferId, @required this.eventId, this.columnLayout = false, this.overrideShowLabel = false})
      : assert(outcomeId != null),
        assert(betOfferId != null),
        assert(eventId != null),
        assert(columnLayout != null),
        assert(overrideShowLabel != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<_ViewModel>(
        mapper: _mapStateToObservable,
        snapshot: _mapStateToSnapshot,
        widgetBuilder: _buildWidget
    );
  }

  Observable<_ViewModel> _mapStateToObservable(AppStore store) {
    return Observable.combineLatest3(
        store.outcomeStore[outcomeId].observable,
        store.betOfferStore[betOfferId].observable,
        store.eventStore[eventId].observable,
            (outcome, betOffer, event) => new _ViewModel(outcome: outcome, betOffer: betOffer, event: event)
    );
  }

  _ViewModel _mapStateToSnapshot(AppStore store) {
    return new _ViewModel(
        outcome: store.outcomeStore[outcomeId].last,
        betOffer: store.betOfferStore[betOfferId].last,
        event: store.eventStore[eventId].last
    );
  }

  Widget _buildWidget(BuildContext context, _ViewModel viewModel) {
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
                    child: _buildContent(viewModel, model)),
              ));
        });
  }

  Widget _buildContent(_ViewModel viewModel, MainModel model) {
    var label = _formatLabel(viewModel);
    if (columnLayout) {
      if (label != null) {
        return new Column(
          children: <Widget>[
            new Expanded(child: new Center(child: _buildLabel(label))),
            new Expanded(child: new Center(child: _buildOdds(viewModel, model)))
          ],
        );
      } else {
        return new Column(
          children: <Widget>[
            new Expanded(child: new Center(child: _buildOdds(viewModel, model)))
          ],
        );
      }
    }

    if (label != null) {
      return new Row(
        children: <Widget>[
          new Expanded(child: _buildLabel(label)),
          _buildOdds(viewModel, model)
        ],
      );
    } else {
      return new Row(
        children: <Widget>[
          new Expanded(child: _buildOdds(viewModel, model)),
        ],
      );
    }
  }

  Text _buildOdds(_ViewModel viewModel, MainModel model) {
    return new Text(
        _formatOdds(viewModel.outcome.odds, model.oddsFormat),
        style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold));
  }

  Text _buildLabel(String label) {
    return new Text(label ?? "?", style: new TextStyle(color: Colors.white, fontSize: 12.0));
  }

  String _formatLabel(_ViewModel viewModel) {
    var outcome = viewModel.outcome;
    var betoffer = viewModel.betOffer;
    var event = viewModel.event;

    if ((
        betoffer.betOfferType.id == BetOfferTypes.overUnder ||
            betoffer.betOfferType.id == BetOfferTypes.handicap ||
            betoffer.betOfferType.id == BetOfferTypes.asianOverUnder) && outcome.line != null) {
      return outcome.label + " " + (
          outcome.line / 1000).toString();
    }
    if (!overrideShowLabel && (
        betoffer.betOfferType.id == BetOfferTypes.headToHead ||
            betoffer.betOfferType.id == BetOfferTypes.winner ||
            betoffer.betOfferType.id == BetOfferTypes.position ||
            betoffer.betOfferType.id == BetOfferTypes.goalScorer)) {
      return null;
    }
    if (betoffer.betOfferType.id == BetOfferTypes.doubleChance) {
      if (outcome.type == OutcomeType.ONE_OR_CROSS)
        return event.homeName + " or Draw";
      if (outcome.type == OutcomeType.ONE_OR_TWO)
        return event.homeName + " or " + event.awayName;
      if (outcome.type == OutcomeType.CROSS_OR_TWO)
        return event.awayName + " or Draw";
    }
    if (betoffer.betOfferType.id == BetOfferTypes.asianHandicap) {
      return outcome.label + (
          outcome.line > 0 ? "  +" : "  ") + (
          (
              outcome.line) / 1000).toString();
    }

    if (outcome.type == OutcomeType.CROSS)
      return "Draw";
    if (outcome.type == OutcomeType.ONE)
      return event.homeName;
    if (outcome.type == OutcomeType.TWO)
      return event.awayName;

    return outcome.label;
  }

  String _formatOdds(Odds odds, OddsFormat format) {
    switch (format) {
      case OddsFormat.Fractional:
        return odds.fractional ?? "";
      case OddsFormat.American:
        return odds.american ?? "";
      case OddsFormat.Decimal:
      default:
        return (
            (
                odds.decimal ?? 1000) / 1000).toString();
    }
  }
}

class _ViewModel {
  final Outcome outcome;
  final BetOffer betOffer;
  final Event event;

  _ViewModel({@required this.outcome, @required this.betOffer, @required this.event});
}
