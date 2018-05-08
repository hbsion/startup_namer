import 'package:flutter/material.dart';
import 'package:rxdart/src/observable.dart';
import 'package:startup_namer/app_drawer.dart';
import 'package:startup_namer/data/event_collection.dart';
import 'package:startup_namer/data/event_collection_key.dart';
import 'package:startup_namer/store/actions.dart';
import 'package:startup_namer/store/app_store.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/widgets/app_toolbar.dart';
import 'package:startup_namer/widgets/platform_circular_progress_indicator.dart';

class HomePage extends StatelessWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new CustomScrollView(
          slivers: <Widget>[new AppToolbar(title: "Home"), _buildBody(context)],
        ),
        drawer: new AppDrawer(onSelect: (Widget page) {}));
  }

  Widget _buildBody(BuildContext context) {
    return new StoreConnector<_ViewModel>(
        mapper: _mapStateToViewModel, widgetBuilder: _buildView,
        action: landingPage(),
    );
  }

  Widget _buildView(BuildContext context, _ViewModel model) {
    if (model == null) {
      return new SliverFillRemaining(
        child: new Container(
          child: new Center(
            child: new PlatformCircularProgressIndicator(),
          ),
        ),
      );
    }
    return SliverFillRemaining(child: Text("home"));
  }

  Observable<_ViewModel> _mapStateToViewModel(AppStore appStore) {
    return Observable.combineLatest6(
        appStore
            .collectionStore[new EventCollectionKey(
            type: EventCollectionType.landingLiveRightNow)]
            .observable,
        appStore
            .collectionStore[new EventCollectionKey(
            type: EventCollectionType.landingStartingSoon)]
            .observable,
        appStore
            .collectionStore[new EventCollectionKey(
            type: EventCollectionType.landingHighlights)]
            .observable,
        appStore
            .collectionStore[new EventCollectionKey(
            type: EventCollectionType.landingPopular)]
            .observable,
        appStore
            .collectionStore[new EventCollectionKey(
            type: EventCollectionType.landingNextOff)]
            .observable,
        appStore
            .collectionStore[new EventCollectionKey(
            type: EventCollectionType.landingShocker)]
            .observable,
            (live, soon, highlights, popular, nexOff, shocker) =>
        new _ViewModel(live, soon, highlights, popular, nexOff, shocker));
  }
}

class _ViewModel {
  final EventCollection live;
  final EventCollection soon;
  final EventCollection popular;
  final EventCollection highlights;
  final EventCollection nextOff;
  final EventCollection shocker;

  _ViewModel(this.live, this.soon, this.popular, this.highlights, this.nextOff,
      this.shocker);
}
