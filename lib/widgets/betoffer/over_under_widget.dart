import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:svan_play/data/outcome.dart';
import 'package:svan_play/data/outcome_type.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/widgets/outcome_widget.dart';

class OverUnderWidget extends StatelessWidget {
  final List<int> outcomeIds;
  final int eventId;

  const OverUnderWidget({Key key, @required this.outcomeIds, @required this.eventId}) : super(key: key);

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: outcomes.map((outcome) => _buildOutcome(context, outcome)).toList(),
      ),
    );
  }

  Widget _buildOutcome(BuildContext context, Outcome outcome) {
    return Container(
        padding: EdgeInsets.only(bottom: 4.0),
        child: new OutcomeWidget(outcomeId: outcome.id, betOfferId: outcome.betOfferId, eventId: eventId));
  }
}
