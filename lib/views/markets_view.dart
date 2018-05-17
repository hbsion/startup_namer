import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:svan_play/data/betoffer.dart';
import 'package:svan_play/store/actions.dart';
import 'package:svan_play/store/app_store.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/widgets/platform_circular_progress_indicator.dart';

class MarketsView extends StatelessWidget {
  final int eventId;

  const MarketsView({Key key, @required this.eventId}) : assert(eventId != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<_ViewModel>(
      stream: _mapStateToStream,
      initalData: _mapStateToInitialData,
      pollAction: betOffers(eventId),
      widgetBuilder: _buildWidget,
    );
  }

  Observable<_ViewModel> _mapStateToStream(AppStore store) {
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

  _ViewModel(this.betOffers);
}