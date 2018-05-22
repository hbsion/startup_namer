import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:svan_play/data/outcome.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/widgets/outcome_widget.dart';

class HalfTimeFullTimeWidget extends StatelessWidget {
  final List<int> outcomeIds;
  final int eventId;

  const HalfTimeFullTimeWidget({Key key, @required this.outcomeIds, @required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<List<Outcome>>(
      initalData: (store) => store.outcomeStore.snapshot(outcomeIds),
      widgetBuilder: _buildWidget,
    );
  }

  Widget _buildWidget(BuildContext context, List<Outcome> outcomes) {
    var outcomesWithHtFt = outcomes.map(_mapOutcome);
    var home = outcomesWithHtFt.where((o) => o.fullTime == 1.0).toList()
      ..sort((o1, o2) => o1.halfTime.compareTo(o2.halfTime));
    var draw = outcomesWithHtFt.where((o) => o.fullTime == 1.5).toList()
      ..sort((o1, o2) => o1.halfTime.compareTo(o2.halfTime));
    var away = outcomesWithHtFt.where((o) => o.fullTime == 2).toList()
      ..sort((o1, o2) => o1.halfTime.compareTo(o2.halfTime));

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

  Widget _buildColumn(BuildContext context, List<_OutcomeWithHtFt> outcomes) {
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

  _OutcomeWithHtFt _mapOutcome(Outcome outcome) {
    var scoreParts = outcome.label.split("/");

    if (scoreParts.length != 2) {
      return new _OutcomeWithHtFt(outcome, 1.0, 1.0);
    }

    return new _OutcomeWithHtFt(outcome, _parseScore(scoreParts[0]), _parseScore(scoreParts[1]));
  }

  double _parseScore(String text) {
    if (text == "X") return 1.5;

    return double.parse(text.trim());
  }
}

class _OutcomeWithHtFt {
  final Outcome outcome;
  final double halfTime;
  final double fullTime;

  _OutcomeWithHtFt(this.outcome, this.halfTime, this.fullTime);
}
