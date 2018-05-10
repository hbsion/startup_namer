import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/data/betoffer.dart';
import 'package:startup_namer/data/betoffer_types.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/event_tags.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/widgets/betoffer/main_racing_betoffer_widget.dart';
import 'package:startup_namer/widgets/betoffer/main_winner_betoffer_widget.dart';
import 'package:startup_namer/widgets/empty_widget.dart';
import 'package:startup_namer/widgets/outcome_widget.dart';

class MainBetOfferWidget extends StatelessWidget {
  final int betOfferId;
  final int eventId;

  const MainBetOfferWidget({Key key, @required this.betOfferId, @required this.eventId})
      : assert(betOfferId != null),
        assert(eventId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<_ViewModel>(
        mapper: (store) =>
            Observable.combineLatest2(
                store.betOfferStore[betOfferId].observable,
                store.eventStore[eventId].observable,
                    (betoffer, event) => new _ViewModel(event, betoffer)
            ),
        snapshot: (store) => new _ViewModel(store.eventStore[eventId].last, store.betOfferStore[betOfferId].last),
        widgetBuilder: _buildWidget
    );
  }

  Widget _buildWidget(BuildContext context, _ViewModel model) {
    if (model == null || model.event == null || model.betOffer == null) return new EmptyWidget();

//    print("Rendering betoffer $betOfferId");
    if (model.event.tags.contains(EventTags.competition) || model.betOffer.betOfferType.id == BetOfferTypes.position) {
      if (model.event.sport == "GALLOPS") {
        return new MainRacingBetOfferWidget(key: new Key(model.betOffer.toString()), betOfferId: model.betOffer.id, eventId: model.event.id);
      }
      return new MainWinnerBetOfferWidget(key: new Key(model.betOffer.toString()), betOfferId: model.betOffer.id, eventId: model.event.id, overrideShowLabel: true);
    }

    return new Row(children: _buildLayout(context, model.betOffer.outcomes));
  }

  List<Widget> _buildLayout(BuildContext context, List<int> outcomeIds) {
    var orientation = MediaQuery
        .of(context)
        .orientation;
    List<Widget> widgets = [];
    if (outcomeIds != null) {
      for (var i = 0; i < outcomeIds.length; ++i) {
        var outcomeId = outcomeIds[i];
        widgets.add(_buildOutcomeWidget(outcomeId, i == (outcomeIds.length - 1), orientation));
      }
    }
    return widgets;
  }

  Widget _buildOutcomeWidget(int outcomeId, bool isLast, Orientation orientation) {
    OutcomeWidget widget = new OutcomeWidget(
        key: new Key(outcomeId.toString()),
        outcomeId: outcomeId,
        betOfferId: betOfferId,
        eventId: eventId,
        columnLayout: orientation == Orientation.landscape);

    if (!isLast) {
      return
        new Expanded(child: new Padding(
            padding: EdgeInsets.only(right: 4.0),
            child: widget
        )
        );
    } else {
      return new Expanded(child: widget);
    }
  }
}

class _ViewModel {
  final Event event;
  final BetOffer betOffer;

  _ViewModel(this.event, this.betOffer);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is _ViewModel &&
              runtimeType == other.runtimeType &&
              event == other.event &&
              betOffer == other.betOffer;

  @override
  int get hashCode =>
      event.hashCode ^
      betOffer.hashCode;
  
}