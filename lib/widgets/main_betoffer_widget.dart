import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/data/betoffer.dart';
import 'package:startup_namer/data/betoffer_types.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/event_tags.dart';
import 'package:startup_namer/store/empty_widget.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/widgets/betoffer/winner_betoffer_widget.dart';
import 'package:startup_namer/widgets/outcome_widget.dart';
import 'package:tuple/tuple.dart';

class MainBetOfferWidget extends StatelessWidget {
  final int betOfferId;
  final int eventId;

  const MainBetOfferWidget({Key key, @required this.betOfferId, @required this.eventId})
      : assert(betOfferId != null),
        assert(eventId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<Tuple2<BetOffer, Event>>(
        mapper: (store) =>
            Observable.combineLatest2(
                store.betOfferStore[betOfferId].observable,
                store.eventStore[eventId].observable,
                    (betoffer, event) => new Tuple2(betoffer, event)
            ),
        snapshot: (store) => new Tuple2(store.betOfferStore[betOfferId].last, store.eventStore[eventId].last),
        widgetBuilder: _buildWidget
    );
  }

  Widget _buildWidget(BuildContext context, Tuple2<BetOffer, Event> model) {
    if (model == null || model.item1 == null || model.item2 == null) return new EmptyWidget();

    if (model.item2.tags.contains(EventTags.competition) || model.item1.betOfferType.id == BetOfferTypes.position) {
      return new WinnerBetOfferWidget(betOfferId: model.item1.id, eventId: model.item2.id, overrideShowLabel: true);
    }

    return new Row(children: _buildLayout(context, model.item1.outcomes));
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
    OutcomeWidget widget = new OutcomeWidget(outcomeId: outcomeId,
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
