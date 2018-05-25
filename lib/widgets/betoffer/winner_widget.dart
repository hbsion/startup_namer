import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:svan_play/data/betoffer.dart';
import 'package:svan_play/data/outcome.dart';
import 'package:svan_play/store/app_store.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/widgets/empty_widget.dart';
import 'package:svan_play/widgets/outcome_widget.dart';

class WinnerWidget extends StatelessWidget {
  final List<int> outcomeIds;
  final int eventId;

  const WinnerWidget({Key key, @required this.outcomeIds, @required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<_ViewModel>(
      initalData: _initalData,
      widgetBuilder: _buildWidget,
    );
  }

  _ViewModel _initalData(AppStore store) {
    var outcomes = store.outcomeStore.snapshot(outcomeIds);
    return _ViewModel(outcomes, store.betOfferStore.snapshot(outcomes.map((oc)=> oc.betOfferId).toSet()));
  }

  Widget _buildWidget(BuildContext context, _ViewModel model) {
    model.outcomes.sort((a, b) => ((a.odds.decimal ?? 0) - (b.odds.decimal ?? 0)));

    List<_Player> players = model.outcomes.fold([], (state, outcome) {
      var player = state.firstWhere((p) => p.name == outcome.label, orElse: () => null);
      if (player == null) {
        player = new _Player(outcome.label);
        state.add(player);
      }
      player.outcomes.add(outcome);
      return state;
    });

    List<Widget> widgets = [];
    widgets.add(_buildHeader(context, model));
    widgets.addAll(_buildPlayers(context, model, players));

    return Column(
      children: widgets,
    );
  }

  Widget _buildHeader(BuildContext context, _ViewModel model) {
    List<Widget> widgets = [];
    widgets.add(Expanded(flex: 3, child: new EmptyWidget()));
    for (var bo in model.betOffers) {
      widgets.add(Expanded(flex: 1, child: new Center(child: new Text(bo.betOfferType.name))));
    }
    return new Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: new Row(
        children: widgets,
      ),
    );
  }

  Iterable<Widget> _buildPlayers(BuildContext context, _ViewModel model, List<_Player> players) sync* {
    for (var player in players) {
      yield new Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: new Row(
          children: _buildPlayer(context, player, model).toList(),
        ),
      );
    }
  }

  Iterable<Widget> _buildPlayer(BuildContext context, _Player player, _ViewModel model) sync* {
    yield Expanded(flex: 3, child: new Text(player.name));

    for (var bo in model.betOffers) {
      Outcome outcome = player.outcomes.firstWhere((oc) => oc.betOfferId == bo.id, orElse: () => null);
      yield Expanded(flex: 1, child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: _buildOutcome(outcome),
      ));
    }
  }

  Widget _buildOutcome(Outcome outcome, {overrideShowLabel = false}) {
    if (outcome == null) return EmptyWidget();
    return new OutcomeWidget(
        outcomeId: outcome.id, betOfferId: outcome.betOfferId, eventId: eventId, overrideShowLabel: overrideShowLabel);
  }
}

class _ViewModel {
  final List<Outcome> outcomes;
  final List<BetOffer> betOffers;

  _ViewModel(this.outcomes, this.betOffers);
}

class _Player {
  String name;
  List<Outcome> outcomes = [];

  _Player(this.name);
}
