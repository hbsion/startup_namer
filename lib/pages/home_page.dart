import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/app_drawer.dart';
import 'package:startup_namer/data/event_collection.dart';
import 'package:startup_namer/data/event_collection_key.dart';
import 'package:startup_namer/store/actions.dart';
import 'package:startup_namer/store/app_store.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/widgets/app_toolbar.dart';
import 'package:startup_namer/widgets/cards/next_off_card.dart';
import 'package:startup_namer/widgets/platform_circular_progress_indicator.dart';

class HomePage extends StatelessWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<_ViewModel>(
        mapper: _mapStateToViewModel, widgetBuilder: _buildView, action: landingPage());
  }

  Observable<_ViewModel> _mapStateToViewModel(AppStore appStore) {
    return Observable.combineLatest6(
        appStore.collectionStore[new EventCollectionKey(type: EventCollectionType.landingLiveRightNow)].observable,
        appStore.collectionStore[new EventCollectionKey(type: EventCollectionType.landingStartingSoon)].observable,
        appStore.collectionStore[new EventCollectionKey(type: EventCollectionType.landingHighlights)].observable,
        appStore.collectionStore[new EventCollectionKey(type: EventCollectionType.landingPopular)].observable,
        appStore.collectionStore[new EventCollectionKey(type: EventCollectionType.landingNextOff)].observable,
        appStore.collectionStore[new EventCollectionKey(type: EventCollectionType.landingShocker)].observable,
        (live, soon, highlights, popular, nexOff, shocker) =>
            new _ViewModel(live, soon, highlights, popular, nexOff, shocker));
  }

  Widget _buildView(BuildContext context, _ViewModel model) {
    var slivers = <Widget>[new AppToolbar(title: "Home")];

    if (model == null) {
      slivers.add(new SliverFillRemaining(
        child: new Container(
          child: new Center(
            child: new PlatformCircularProgressIndicator(),
          ),
        ),
      ));
    } else {
      slivers.addAll(_buildCards(model).map((widget) => SliverToBoxAdapter(child: widget)));
    }

    return new Scaffold(
        body: new CustomScrollView(
          slivers: slivers,
        ),
        drawer: new AppDrawer(onSelect: (Widget page) {}));
  }

  Iterable<Widget> _buildCards(_ViewModel model) sync* {
    for (var eventId in model.nextOff.eventIds) {
      yield new NextOffCard(eventId: eventId);
    }
//    for (var eventId in model.live.eventIds) {
//      yield new LiveRightNowCard(eventId: eventId);
//    }
//    for (var eventId in model.highlights.eventIds) {
//      yield new TrendingCard(eventId: eventId);
//    }
//
//    if (model.popular.eventIds.length > 0) {
//      yield new HighlightsCard(eventIds: model.popular.eventIds);
//    }
//
//    for (var eventId in model.soon.eventIds) {
//      yield new StartingSoonCard(eventId: eventId);
//    }
  }
}

class _ViewModel {
  final EventCollection live;
  final EventCollection soon;
  final EventCollection popular;
  final EventCollection highlights;
  final EventCollection nextOff;
  final EventCollection shocker;

  _ViewModel(this.live, this.soon, this.popular, this.highlights, this.nextOff, this.shocker);
}
