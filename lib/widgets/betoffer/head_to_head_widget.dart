import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:quiver/collection.dart';
import 'package:svan_play/app_theme.dart';
import 'package:svan_play/data/outcome.dart';
import 'package:svan_play/data/outcome_type.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/widgets/empty_widget.dart';
import 'package:svan_play/widgets/outcome_widget.dart';

class HeadToHeadWidget extends StatelessWidget {
  final List<int> outcomeIds;
  final int eventId;

  const HeadToHeadWidget({Key key, @required this.outcomeIds, @required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<List<Outcome>>(
      initalData: (store) => store.outcomeStore.snapshot(outcomeIds),
      widgetBuilder: _buildWidget,
    );
  }

  Widget _buildWidget(BuildContext context, List<Outcome> outcomes) {
    if (outcomes.any((outcome) => outcome.type == OutcomeType.YES || outcome.type == OutcomeType.NO)) {
      return _buildYesNoFlavor(context, outcomes);
    } else {
      return _buildHeadToHeadFlavor(context, outcomes);
    }
  }

  Widget _buildYesNoFlavor(BuildContext context, List<Outcome> outcomes) {
    List<_YesNo> rows = outcomes.fold([], (state, outcome) {
      var yesNo = state.firstWhere((yn) => yn.betOfferId == outcome.betOfferId, orElse: () => null);
      if (yesNo == null) {
        yesNo = new _YesNo(outcome.betOfferId);
        state.add(yesNo);
      }
      yesNo.participant = outcome.participant ?? yesNo.participant;

      if (outcome.type == OutcomeType.YES) {
        yesNo.yes = outcome;
      } else if (outcome.type == OutcomeType.NO) {
        yesNo.no = outcome;
      }
      return state;
    });

    var yesLabel = rows.firstWhere((r) => r.yes != null, orElse: () => null)?.yes?.label ?? "Yes";
    var noLabel = rows.firstWhere((r) => r.no != null, orElse: () => null)?.no?.label ?? "No";

    List<Widget> widgets = [];
    widgets.add(new Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: new Row(
        children: <Widget>[
          Expanded(flex: 3, child: new EmptyWidget()),
          Expanded(flex: 1, child: new Center(child: new Text(yesLabel))),
          Expanded(flex: 1, child: new Center(child: new Text(noLabel)))
        ],
      ),
    ));

    for (var row in rows) {
      widgets.add(new Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: new Row(
          children: <Widget>[
            Expanded(flex: 3, child: new Text(row.participant)),
            Expanded(flex: 1, child: _buildOutcome(row.yes)),
            Expanded(
                flex: 1,
                child: new Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: _buildOutcome(row.no),
                ))
          ],
        ),
      ));
    }

    return Column(
      children: widgets,
    );
  }

  Widget _buildHeadToHeadFlavor(BuildContext context, List<Outcome> outcomes) {
    Multimap<int, Outcome> rows = new Multimap.fromIterable(outcomes, key: (el) => el.betOfferId);

    List<Widget> widgets = [];
    var keys = rows.keys.toList();

    for (var i = 0; i < keys.length; ++i) {
      var betOfferId = keys[i];
      var outcomes = rows[betOfferId];
      var title = outcomes.map((oc) => oc.participant).where((label) => label != null).join(" - ");
      if (title != null && title.isNotEmpty) {
        widgets.add(new Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(title),
        ));
      }

      for (var outcome in outcomes) {
        widgets.add(new Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: _buildOutcome(outcome, overrideShowLabel: true),
        ));
      }

      if (i < (rows.length - 1)) {
        widgets.add(
          Divider(height: 8.0, color: AppTheme.of(context).list.itemDividerColor),
        );
      }
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
  }

  Widget _buildOutcome(Outcome outcome, {overrideShowLabel = false}) {
    if (outcome == null) return EmptyWidget();
    return new OutcomeWidget(
        outcomeId: outcome.id, betOfferId: outcome.betOfferId, eventId: eventId, overrideShowLabel: overrideShowLabel);
  }
}

class _YesNo {
  String participant = "";
  Outcome yes;
  Outcome no;
  int betOfferId;

  _YesNo(this.betOfferId);
}
