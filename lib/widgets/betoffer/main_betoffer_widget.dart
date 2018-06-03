import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:svan_play/data/betoffer.dart';
import 'package:svan_play/data/betoffer_types.dart';
import 'package:svan_play/data/event.dart';
import 'package:svan_play/data/event_tags.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/widgets/betoffer/main_racing_betoffer_widget.dart';
import 'package:svan_play/widgets/betoffer/main_winner_betoffer_widget.dart';
import 'package:svan_play/widgets/empty_widget.dart';
import 'package:svan_play/widgets/outcome_widget.dart';

class MainBetOfferWidget extends StatelessWidget {
  final int betOfferId;
  final int eventId;
  final Orientation defaultOrientation;

  const MainBetOfferWidget({Key key, @required this.betOfferId, @required this.eventId, this.defaultOrientation})
      : assert(betOfferId != null),
        assert(eventId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<_ViewModel>(
        stream: (store) => Observable.combineLatest2(store.betOfferStore[betOfferId].observable,
            store.eventStore[eventId].observable, (betoffer, event) => new _ViewModel(event, betoffer)),
        initalData: (store) => new _ViewModel(store.eventStore[eventId].latest, store.betOfferStore[betOfferId].latest),
        widgetBuilder: _buildWidget);
  }

  Widget _buildWidget(BuildContext context, _ViewModel model) {
    if (model == null || model.event == null || model.betOffer == null) return new EmptyWidget();

    if (model.event.tags.contains(EventTags.competition) || model.betOffer.betOfferType.id == BetOfferTypes.position) {
      if (model.event.sport == "GALLOPS") {
        return new MainRacingBetOfferWidget(
            key: new Key(model.betOffer.toString()), betOfferId: model.betOffer.id, eventId: model.event.id);
      }
      return new MainWinnerBetOfferWidget(
          key: new Key(model.betOffer.toString()),
          betOfferId: model.betOffer.id,
          eventId: model.event.id,
          overrideShowLabel: true);
    }
    if (model.betOffer.betOfferType.id == BetOfferTypes.doubleChance) {
      return _buildVerticalLayout(context, model.betOffer.outcomes);
    }

    return _buildHorizontalLayout(context, model.betOffer.outcomes);
  }

  Widget _buildHorizontalLayout(BuildContext context, List<int> outcomeIds) {
    var orientation = MediaQuery.of(context).orientation;
    List<Widget> widgets = [];
    if (outcomeIds != null) {
      for (var i = 0; i < outcomeIds.length; ++i) {
        var outcomeId = outcomeIds[i];
        widgets.add(_horizontalWrap(_buildOutcomeWidget(outcomeId, defaultOrientation ?? orientation), i == (outcomeIds.length - 1)));
      }
    }
    return Row(children: widgets);
  }

  Widget _buildVerticalLayout(BuildContext context, List<int> outcomeIds) {
    var orientation = MediaQuery.of(context).orientation;
    List<Widget> widgets = [];
    if (outcomeIds != null) {
      for (var i = 0; i < outcomeIds.length; ++i) {
        var outcomeId = outcomeIds[i];
        widgets.add(_verticalWrap(_buildOutcomeWidget(outcomeId, defaultOrientation ?? orientation), i == (outcomeIds.length - 1)));
      }
    }

    return Column(children: widgets);
  }

  Widget _buildOutcomeWidget(int outcomeId, Orientation orientation) {
    return new OutcomeWidget(
        key: new Key(outcomeId.toString()),
        outcomeId: outcomeId,
        betOfferId: betOfferId,
        eventId: eventId,
        columnLayout: orientation == Orientation.landscape);
  }

  Widget _horizontalWrap(Widget widget, bool isLast) {
    if (!isLast) {
      return new Expanded(child: new Padding(padding: EdgeInsets.only(right: 4.0), child: widget));
    } else {
      return new Expanded(child: widget);
    }
  }

  Widget _verticalWrap(Widget widget, bool isLast) {
    if (!isLast) {
      return new Padding(padding: EdgeInsets.only(bottom: 4.0), child: widget);
    } else {
      return widget;
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
      other is _ViewModel && runtimeType == other.runtimeType && event == other.event && betOffer == other.betOffer;

  @override
  int get hashCode => event.hashCode ^ betOffer.hashCode;
}
