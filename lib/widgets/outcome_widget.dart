import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:startup_namer/data/betoffer.dart';
import 'package:startup_namer/data/betoffer_types.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/odds.dart';
import 'package:startup_namer/data/outcome.dart';
import 'package:startup_namer/data/outcome_status.dart';
import 'package:startup_namer/data/outcome_type.dart';
import 'package:startup_namer/models/main_model.dart';
import 'package:startup_namer/models/odds_format.dart';
import 'package:startup_namer/store/app_store.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/widgets/empty_widget.dart';

class OutcomeWidget extends StatefulWidget {
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
  _State createState() => new _State();
}

class _State extends State<OutcomeWidget> {
  Timer _timer;

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<_ViewModel>(
        mapper: _mapStateToObservable,
        snapshot: _mapStateToSnapshot,
        widgetBuilder: _buildWidget
    );
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    super.dispose();
  }

  Observable<_ViewModel> _mapStateToObservable(AppStore store) {
    return Observable.combineLatest3(
        store.outcomeStore[widget.outcomeId].observable,
        store.betOfferStore[widget.betOfferId].observable,
        store.eventStore[widget.eventId].observable,
            (outcome, betOffer, event) => new _ViewModel(outcome: outcome, betOffer: betOffer, event: event)
    );
  }

  _ViewModel _mapStateToSnapshot(AppStore store) {
    return new _ViewModel(
        outcome: store.outcomeStore[widget.outcomeId].last,
        betOffer: store.betOfferStore[widget.betOfferId].last,
        event: store.eventStore[widget.eventId].last
    );
  }

  Widget _buildWidget(BuildContext context, _ViewModel viewModel) {
    if (viewModel == null || viewModel.outcome == null || viewModel.betOffer == null || viewModel.event == null) {
      return _buildPlaceholder();
    }
    _handleOddsChange(viewModel);

    return new ScopedModelDescendant<MainModel>(
        builder: (context, child, model) {
          return new Container(
              height: widget.columnLayout ? 48.0 : 38.0,
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                color: _isSuspended(viewModel) ? Colors.grey : Color.fromRGBO(0x00, 0xad, 0xc9, 1.0),
              ),
              child: _buildContentWrapper(viewModel, model));
        });
  }

  Container _buildPlaceholder() {
    return new Container(
        height: widget.columnLayout ? 48.0 : 38.0,
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(3.0),
            color: Colors.grey
        ),
        child: new EmptyWidget());
  }

  void _handleOddsChange(_ViewModel viewModel) {
    if (_oddsDiff(viewModel.outcome) != 0) {
      if (_timer != null) {
        _timer.cancel();
      }
      _timer = new Timer(new Duration(seconds: 6), () {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  Widget _buildContentWrapper(_ViewModel viewModel, MainModel model) {
    if (_isSuspended(viewModel)) {
      return _buildContent(viewModel, model);
    }

    return new Material(
      color: Colors.transparent,
      child: new InkWell(
          onTap: () => print("outcome tap " + DateTime.now().toString()),
          child: _buildContent(viewModel, model)),
    );
  }

  bool _isSuspended(_ViewModel viewModel) =>
      viewModel.betOffer.suspended || viewModel.outcome.status == OutcomeStatus.SUSPENDED;

  Widget _buildContent(_ViewModel viewModel, MainModel model) {
    var label = _formatLabel(viewModel);
    if (widget.columnLayout) {
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

  Widget _buildOdds(_ViewModel viewModel, MainModel model) {
    var formatOdds = _formatOdds(viewModel.outcome.odds, model.oddsFormat);

    int oddsDiff = _oddsDiff(viewModel.outcome);
    if (oddsDiff != 0) {
      Color color = oddsDiff > 0 ? Colors.lightGreenAccent : Colors.red;
      Icon icon = new Icon(oddsDiff > 0 ? Icons.arrow_upward : Icons.arrow_downward, color: color, size: 12.0);
      return new Row(children: <Widget>[
        icon,
        new Text(
            formatOdds,
            style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold))
      ]);
    }

    return new Text(
        formatOdds,
        style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold));
  }

  int _oddsDiff(Outcome outcome) {
    if (outcome != null && outcome.odds.decimal != null && outcome.lastOdds != null &&
        outcome.lastOdds.decimal != null) {
      int seconds = DateTime
          .now()
          .difference(outcome.oddsChanged)
          .inSeconds;
//        print("Changed: " + outcome.oddsChanged.toString() + " diff: " + seconds.toString());
      if (seconds < 5) {
        return outcome.odds.decimal - outcome.lastOdds.decimal;
      }
    }
    return 0;
  }

  Text _buildLabel(String label) {
    return new Text(label ?? "?", overflow: TextOverflow.fade,
        softWrap: false,
        style: new TextStyle(color: Colors.white, fontSize: 12.0));
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
    if (!widget.overrideShowLabel && (
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is _ViewModel &&
              runtimeType == other.runtimeType &&
              outcome == other.outcome &&
              betOffer == other.betOffer &&
              event == other.event;

  @override
  int get hashCode =>
      outcome.hashCode ^
      betOffer.hashCode ^
      event.hashCode;

}
