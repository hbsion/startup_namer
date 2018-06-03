import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:svan_play/app_theme.dart';
import 'package:svan_play/data/betoffer.dart';
import 'package:svan_play/data/outcome.dart';
import 'package:svan_play/data/silk_image.dart';
import 'package:svan_play/pages/event_page.dart';
import 'package:svan_play/store/actions.dart';
import 'package:svan_play/store/app_store.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/widgets/outcome_widget.dart';

class MainRacingBetOfferWidget extends StatelessWidget {
  final int betOfferId;
  final int eventId;

  const MainRacingBetOfferWidget({Key key, @required this.betOfferId, @required this.eventId})
      : assert(betOfferId != null),
        assert(eventId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<_ViewModel>(
        stream: _mapStateToViewModel,
        initalData: _mapStateToSnapshot,
        initAction: loadSilks,
        widgetBuilder: _buildWidget);
  }

  void loadSilks(Dispatcher dispatch, AppStore store) {
    if (!store.silkStore.hasSilks(eventId)) {
      silks(eventId)(dispatch);
    }
  }

  _ViewModel _mapStateToSnapshot(AppStore store) {
    return new _ViewModel(store.outcomeStore.snapshotByBetOffer(betOfferId), store.betOfferStore[betOfferId].latest,
        store.silkStore[eventId].latest);
  }

  Observable<_ViewModel> _mapStateToViewModel(AppStore store) {
    return Observable.combineLatest3(
        store.outcomeStore.byBetOfferId(betOfferId).observable,
        store.betOfferStore[betOfferId].observable,
        store.silkStore[eventId].observable,
        (outcomes, betOffer, silks) => new _ViewModel(outcomes, betOffer, silks));
  }

  Widget _buildWidget(BuildContext context, _ViewModel model) {
    return new Column(children: _buildChilds(context, model).toList());
  }

  Iterable<Widget> _buildChilds(BuildContext context, _ViewModel model) sync* {
    yield new Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: new Text(model?.betOffer?.eachWay?.terms ?? "", style: Theme.of(context).textTheme.caption),
    );
    model.outcomes.sort((a, b) => a.odds?.decimal?.compareTo(b.odds?.decimal ?? 0) ?? 0);
    for (var outcome in model.outcomes.take(3)) {
      yield new Container(margin: const EdgeInsets.only(bottom: 4.0), child: _buildOutcomeRow(model, outcome, context));
    }

    if (model.outcomes.length > 3) {
      yield new Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Divider(height: 1.0, color: AppTheme.of(context).list.itemDividerColor),
      );
      yield new InkWell(
          onTap: _navigateToEvent(context),
          child: new Container(
            padding: EdgeInsets.all(12.0),
            child: new Row(children: <Widget>[
              new Expanded(child: new Center(child: new Text("Show all ${model.outcomes.length} runners")))
            ]),
          ));
    }
  }

  Widget _buildOutcomeRow(_ViewModel model, Outcome outcome, BuildContext context) {
    SilkImage silk = model.silks?.firstWhere((img) => img.participantId == outcome.participantId, orElse: () => null);
    return new Row(
      children: <Widget>[
        new Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: silk != null && silk.image != null
                ? new Image.memory(silk.image, width: 36.0, height: 26.0)
                : new Image.asset('assets/silk_placeholder.png', width: 36.0, height: 26.0)),
        new Expanded(
          child: Text(
            outcome.label,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        new Container(
          width: 100.0,
          child: new OutcomeWidget(
            outcomeId: outcome.id,
            betOfferId: betOfferId,
            eventId: eventId,
          ),
        )
      ],
    );
  }

  VoidCallback _navigateToEvent(BuildContext context) {
    return () =>
        Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new EventPage(eventId: eventId)));
  }
}

class _ViewModel {
  final List<SilkImage> silks;
  final List<Outcome> outcomes;
  final BetOffer betOffer;

  _ViewModel(this.outcomes, this.betOffer, this.silks);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          new ListEquality().equals(outcomes, other.outcomes) &&
          new ListEquality().equals(silks, other.silks) &&
          betOffer == other.betOffer;

  @override
  int get hashCode => outcomes.hashCode ^ betOffer.hashCode;
}
