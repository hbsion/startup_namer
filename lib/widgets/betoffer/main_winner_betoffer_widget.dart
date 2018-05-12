import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/data/outcome.dart';
import 'package:startup_namer/pages/event_page.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/widgets/outcome_widget.dart';

class MainWinnerBetOfferWidget extends StatelessWidget {
  final int betOfferId;
  final int eventId;
  final bool overrideShowLabel;

  const MainWinnerBetOfferWidget(
      {Key key, @required this.betOfferId, @required this.eventId, this.overrideShowLabel = false})
      : assert(betOfferId != null),
        assert(eventId != null),
        assert(overrideShowLabel != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<List<Outcome>>(
        mapper: _mapStateToViewModel, snapshot: _mapStateToSnapshot, widgetBuilder: _buildWidget);
  }

  List<Outcome> _mapStateToSnapshot(store) => store.outcomeStore.snapshotByBetOffer(betOfferId);

  Observable<List<Outcome>> _mapStateToViewModel(store) => store.outcomeStore.byBetOfferId(betOfferId).observable;

  Widget _buildWidget(BuildContext context, List<Outcome> model) {
    return new Column(children: _buildChilds(context, model).toList());
  }

  Iterable<Widget> _buildChilds(BuildContext context, List<Outcome> model) sync* {
    model.sort((a, b) => a.odds.decimal.compareTo(b.odds.decimal));
    for (var outcome in model.take(4)) {
      yield new Container(
          margin: const EdgeInsets.only(bottom: 4.0),
          child: new OutcomeWidget(
            outcomeId: outcome.id,
            betOfferId: betOfferId,
            eventId: eventId,
            overrideShowLabel: overrideShowLabel,
          ));
    }

    if (model.length > 4) {
      yield new InkWell(
          onTap: _navigateToEvent(context),
          child: new Container(
            padding: EdgeInsets.all(12.0),
            child: new Row(children: <Widget>[
              new Expanded(child: new Center(child: new Text("Show all ${model.length} participants")))
            ]),
          ));
    }
  }

  VoidCallback _navigateToEvent(BuildContext context) {
    return () =>
        Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new EventPage(eventId: eventId)));
  }
}
