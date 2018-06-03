import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:svan_play/app_theme.dart';
import 'package:svan_play/data/event.dart';
import 'package:svan_play/data/outcome.dart';
import 'package:svan_play/data/outcome_criterion.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/widgets/empty_widget.dart';
import 'package:svan_play/widgets/outcome_widget.dart';

class GoalScorerWidget extends StatelessWidget {
  final List<int> outcomeIds;
  final int eventId;

  const GoalScorerWidget({Key key, @required this.outcomeIds, @required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<_ViewModel>(
      initalData: (store) => new _ViewModel(store.outcomeStore.snapshot(outcomeIds), store.eventStore[eventId].latest),
      widgetBuilder: _buildWidget,
    );
  }

  Widget _buildWidget(BuildContext context, _ViewModel model) {
    var homeTeam = new _Team(model.event.homeName);
    var awayTeam = new _Team(model.event.awayName);

    List<OutcomeCriterion> criterias = [];

    for (var outcome in model.outcomes) {
      var player = outcome.homeTeamMember ? _resolvePlayer(outcome, homeTeam) : _resolvePlayer(outcome, awayTeam);
      player.outcomes.add(outcome);
      if (outcome.criterion != null && !criterias.contains(outcome.criterion)) {
        criterias.add(outcome.criterion);
      }
    }
    criterias.sort((a, b) => a.type - b.type);

    return Column(
      children: <Widget>[
        _buildTeamHeader(context, homeTeam, criterias),
        _buildTeamPlayers(context, homeTeam.players.values.toList(), criterias),
        _buildTeamHeader(context, awayTeam, criterias),
        _buildTeamPlayers(context, awayTeam.players.values.toList(), criterias),
      ],
    );
  }

  Widget _buildTeamHeader(BuildContext context, _Team team, List<OutcomeCriterion> criterias) {
    return Column(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Text(team.name, style: Theme.of(context).textTheme.subhead.merge(TextStyle(fontWeight: FontWeight.w500))),
        ),
        Row(
          children: criterias.map((oc) {
            return new Expanded(
                child: new Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: new Center(
                  child: new Column(
                children: <Widget>[
                  Text(oc.name),
                  new Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                    child: new Divider(color: AppTheme.of(context).list.headerDivider, height: 2.0),
                  )
                ],
              )),
            ));
          }).toList(),
        )
      ],
    );
  }

  Widget _buildTeamPlayers(BuildContext context, List<_Player> players, List<OutcomeCriterion> criterias) {
    players.sort((a, b) => _playerOdds(a, criterias[0]) - _playerOdds(b, criterias[0]));
    return Column(
      children: players.map((player) => _buildPlayer(context, player, criterias)).toList(),
    );
  }

  int _playerOdds(_Player player, OutcomeCriterion criteria) {
    var outcome = player.outcomes.firstWhere((outcome) => outcome.criterion.type == criteria.type, orElse: () => null);
    return outcome != null ? outcome.odds.decimal : 99999;
  }

  Widget _buildPlayer(BuildContext context, _Player player, List<OutcomeCriterion> criterias) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(player.name),
        ),
        _buildPlayerOutcomes(context, player, criterias),
        new Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: new Divider(color: AppTheme.of(context).list.headerDivider, height: 2.0),
        )
      ],
    );
  }

  Widget _buildPlayerOutcomes(BuildContext context, _Player player, List<OutcomeCriterion> criterias) {
    return Row(
        children: criterias
            .map((oc) => _buildOutcome(context,
                player.outcomes.firstWhere((outcome) => outcome.criterion.type == oc.type, orElse: () => null)))
            .toList());
  }

  Widget _buildOutcome(BuildContext context, Outcome outcome) {
    if (outcome == null) {
      return Expanded(child: new EmptyWidget());
    }

    return Expanded(
        child: new Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: new OutcomeWidget(outcomeId: outcome.id, betOfferId: outcome.betOfferId, eventId: eventId),
    ));
  }

  _Player _resolvePlayer(Outcome outcome, _Team team) {
    var player = team.players[outcome.participantId];
    if (player == null) {
      player = _Player(outcome.label);
      team.players[outcome.participantId] = player;
    }
    return player;
  }
}

class _ViewModel {
  final List<Outcome> outcomes;
  final Event event;

  _ViewModel(this.outcomes, this.event);
}

class _Player {
  final String name;
  final List<Outcome> outcomes = [];

  _Player(this.name);
}

class _Team {
  final String name;
  final Map<int, _Player> players = {};

  _Team(this.name);
}
