import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:svan_play/data/outcome.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/widgets/outcome_widget.dart';

class CorrectScoreWidget extends StatelessWidget {
  final List<int> outcomeIds;
  final int eventId;

  const CorrectScoreWidget({Key key, @required this.outcomeIds, @required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<List<Outcome>>(
      initalData: (store) => store.outcomeStore.snapshot(outcomeIds),
      widgetBuilder: _buildWidget,
    );
  }

  Widget _buildWidget(BuildContext context, List<Outcome> outcomes) {
    var withScore = outcomes.map(_mapOutcome);
    var home = withScore.where((o) => o.homeScore > o.awayScore).toList()
      ..sort((o1, o2) => o1.homeScore - o2.homeScore);
    var draw = withScore.where((o) => o.homeScore == o.awayScore).toList()
      ..sort((o1, o2) => o1.homeScore - o2.homeScore);
    var away = withScore.where((o) => o.homeScore < o.awayScore).toList()
      ..sort((o1, o2) => o1.homeScore - o2.homeScore);

    if (draw.length > 0) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildColumn(context, home),
          new Padding(padding: EdgeInsets.only(left: 4.0)),
          _buildColumn(context, draw),
          new Padding(padding: EdgeInsets.only(left: 4.0)),
          _buildColumn(context, away),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildColumn(context, home),
        new Padding(padding: EdgeInsets.only(left: 4.0)),
        _buildColumn(context, away),
      ],
    );
  }

  Widget _buildColumn(BuildContext context, List<_OutcomeWithScore> outcomes) {
    return new Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: outcomes.map((outcome) => _buildOutcome(context, outcome.outcome)).toList(),
      ),
    );
  }

  Widget _buildOutcome(BuildContext context, Outcome outcome) {
    return Container(
        padding: EdgeInsets.only(bottom: 4.0),
        child: new OutcomeWidget(outcomeId: outcome.id, betOfferId: outcome.betOfferId, eventId: eventId));
  }

  _OutcomeWithScore _mapOutcome(Outcome outcome) {
    var scoreParts = outcome.label.split("-");

    if (scoreParts.length != 2) {
      return new _OutcomeWithScore(outcome, 0, 0);
    }

    return new _OutcomeWithScore(outcome, _parseScore(scoreParts[0]), _parseScore(scoreParts[1]));
  }

  int _parseScore(String text) {
    if (text == "W") return 99999999;

    return int.parse(text.trim());
  }
}

class _OutcomeWithScore {
  final Outcome outcome;
  final int homeScore;
  final int awayScore;

  _OutcomeWithScore(this.outcome, this.homeScore, this.awayScore);
}
