import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:quiver/collection.dart';
import 'package:svan_play/app_theme.dart';
import 'package:svan_play/data/outcome.dart';
import 'package:svan_play/data/outcome_type.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/widgets/empty_widget.dart';
import 'package:svan_play/widgets/outcome_widget.dart';

class ThreeWayHandicapWidget extends StatelessWidget {
  final List<int> outcomeIds;
  final int eventId;

  const ThreeWayHandicapWidget({Key key, @required this.outcomeIds, @required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<List<Outcome>>(
      initalData: (store) => store.outcomeStore.snapshot(outcomeIds),
      widgetBuilder: _buildWidget,
    );
  }

  Widget _buildWidget(BuildContext context, List<Outcome> outcomes) {
    Multimap<int, Outcome> handicaps = Multimap.fromIterable(outcomes, key: (el) => el.line);

    List<int> sorted = handicaps.keys.toList()..sort((a, b) => b - a);

    List<Widget> widgets = [];
    for (var handicap in sorted) {
      var outcomes = handicaps[handicap];
      widgets.add(_buildHandicapLabel(context, handicap));
      widgets.add(_buildRow(context, outcomes));
    }

    return Column(
      children: widgets,
    );
  }

  Widget _buildRow(BuildContext context, List<Outcome> outcomes) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildOutcome(context, outcomes.firstWhere((outcome) => outcome.type == OutcomeType.ONE, orElse: null)),
        new Padding(padding: EdgeInsets.only(left: 4.0)),
        _buildOutcome(context, outcomes.firstWhere((outcome) => outcome.type == OutcomeType.CROSS, orElse: null)),
        new Padding(padding: EdgeInsets.only(left: 4.0)),
        _buildOutcome(context, outcomes.firstWhere((outcome) => outcome.type == OutcomeType.TWO, orElse: null)),
      ],
    );
  }

  Widget _buildOutcome(BuildContext context, Outcome outcome) {
    if (outcome == null) {
      return new EmptyWidget();
    }
    return Expanded(child: new OutcomeWidget(outcomeId: outcome.id, betOfferId: outcome.betOfferId, eventId: eventId));
  }

  Widget _buildHandicapLabel(BuildContext context, int handicap) {
    return new Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Row(
        children: <Widget>[
          Text("Starts"),
          Padding(padding: new EdgeInsets.all(2.0)),
          Text(handicap < 0 ? "0${_formatHandicap(handicap)}" : "${_formatHandicap(handicap)}-0",
              style: TextStyle(color: AppTheme.of(context).brandColor))
        ],
      ),
    );
  }

  int _formatHandicap(int handicap) => (handicap / 1000).floor();
}
