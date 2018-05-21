import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:svan_play/data/outcome.dart';
import 'package:svan_play/data/outcome_type.dart';
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
    var over = outcomes.where((o) => o.type == OutcomeType.OVER && o.line != null).toList()
      ..sort((o1, o2) => o1.line - o2.line);
    var under = outcomes.where((o) => o.type == OutcomeType.UNDER && o.line != null).toList()
      ..sort((o1, o2) => o1.line - o2.line);

    return Row(
      children: <Widget>[
        _buildColumn(context, over),
        new Padding(padding: EdgeInsets.only(left: 4.0)),
        _buildColumn(context, under),
      ],
    );
  }

  Widget _buildColumn(BuildContext context, List<Outcome> outcomes) {
    return new Expanded(
      child: Column(
        children: outcomes.map((outcome) => _buildOutcome(context, outcome)).toList(),
      ),
    );
  }

  Widget _buildOutcome(BuildContext context, Outcome outcome) {
    return Container(
        padding: EdgeInsets.only(bottom: 4.0),
        child: new OutcomeWidget(outcomeId: outcome.id, betOfferId: outcome.betOfferId, eventId: eventId));
  }

  _OutceomeWithScore _mapOutcome(Outcome outcome) {
    var scoreParts = outcome.label.split("-");

    if (scoreParts.length != 2) {
      return new _OutceomeWithScore(outcome, 0, 0);
    }

    return new _OutceomeWithScore(outcome, _parseScore(scoreParts[0]), _parseScore(scoreParts[1]));
  }

  int _parseScore(String text) {
    if (text == "W") return 99999999;

    return int.parse(text.trim());
  }
}

class _OutceomeWithScore {
  final Outcome outcome;
  final int homeScore;
  final int awayScore;

  _OutceomeWithScore(this.outcome, this.homeScore, this.awayScore);
}
