import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:svan_play/data/betoffer.dart';
import 'package:svan_play/data/betoffer_categories.dart';
import 'package:svan_play/data/betoffer_category.dart';
import 'package:svan_play/store/actions.dart';
import 'package:svan_play/store/app_store.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/util/callable.dart';
import 'package:svan_play/widgets/platform_circular_progress_indicator.dart';

class MarketsView extends StatelessWidget {
  final int eventId;
  final int eventGroupId;
  final bool live;

  const MarketsView({Key key, @required this.eventId, @required this.live, @required this.eventGroupId})
      : assert(eventId != null), assert(live != null), assert(eventGroupId != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<_ViewModel>(
      stream: _mapStateToStream,
      initalData: _mapStateToInitialData,
      pollAction: _pollAction(),
      initAction: _intitAction(),
      widgetBuilder: _buildWidget,
    );
  }

  Callable<Dispatcher> _pollAction() {
    return (dispatcher) {
      betOffers(eventId);
    };
  }

  Callable2<Dispatcher, AppStore> _intitAction() {
      return (dispatcher, store) {
        if (!live && !store.categoryStore.has(eventGroupId, BetOfferCategories.preMatchEvent)) {
          categoryGroup(eventGroupId, BetOfferCategories.preMatchEvent)(dispatcher);
        } else if (live) {

        }

      };
    }

  Observable<_ViewModel> _mapStateToStream(AppStore store) {
    if (live) {

    } else {
      
    }
    return store.betOfferStore.byEventId(eventId).observable.map((ids) {
       return _ViewModel(store.betOfferStore.snapshot(ids));
    });
  }

  _ViewModel _mapStateToInitialData(AppStore store) {
    var ids = store.betOfferStore.byEventId(eventId).last;
    return _ViewModel(ids != null ? store.betOfferStore.snapshot(ids) : null);
  }

  Widget _buildWidget(BuildContext context, _ViewModel model) {
    if (model == null || model.betOffers == null) {
      return Center(child: new PlatformCircularProgressIndicator());
    }
    return new Center(
      child: new Text("Markets with ${model.betOffers.length} betoffers"),
    );
  }
}


class _ViewModel {
  final List<BetOffer> betOffers;
  final List<BetOfferCategory> categories;
  final List<BetOfferCategory> selectedCategories;
  final List<BetOfferCategory> instantCategories;

  _ViewModel(this.betOffers, this.categories, {this.selectedCategories = const [], this.instantCategories = const []});

  @override
  bool operator ==(Object other) {
    // used for should update
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;

    _ViewModel otherModel = other;
    if (!const ListEquality().equals(betOffers?.map((bo) => bo.id)?.toList(), otherModel?.betOffers?.map((bo) => bo.id)?.toList())) return false;
    if (!const ListEquality().equals(categories, otherModel.categories)) return false;
    if (!const ListEquality().equals(selectedCategories, otherModel.selectedCategories)) return false;
    if (!const ListEquality().equals(instantCategories, otherModel.instantCategories)) return false;

    return true;
  }

}