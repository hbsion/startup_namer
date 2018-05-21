import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:svan_play/data/event.dart';
import 'package:svan_play/data/outcome.dart';
import 'package:svan_play/data/outcome_type.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/widgets/outcome_widget.dart';

class HandicapWidget extends StatelessWidget {
  final List<int> outcomeIds;
  final int eventId;

  const HandicapWidget({Key key, @required this.outcomeIds, @required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<_ViewModel>(
      initalData: (store) => new _ViewModel(store.outcomeStore.snapshot(outcomeIds), store.eventStore[eventId].last),
      widgetBuilder: _buildWidget,
    );
  }

  Widget _buildWidget(BuildContext context, _ViewModel model) {
    var home = model.outcomes.where((o) => o.label == model.event.homeName && o.line != null).toList()
      ..sort((o1, o2) => o1.line - o2.line);
    var away = model.outcomes.where((o) => o.label == model.event.awayName && o.line != null).toList()
      ..sort((o1, o2) => o1.line - o2.line);

    return Row(
      children: <Widget>[
        _buildColumn(context, home),
        new Padding(padding: EdgeInsets.only(left: 4.0)),
        _buildColumn(context, away),
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
}

class _ViewModel {
  final List<Outcome> outcomes;
  final Event event;

  _ViewModel(this.outcomes, this.event);
}
