import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/app_drawer.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/event_collection_key.dart';
import 'package:startup_namer/store/app_store.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/widgets/app_toolbar.dart';
import 'package:startup_namer/widgets/event_list_item_widget.dart';
import 'package:startup_namer/widgets/section_list_view.dart';

class LiveRightNowPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new CustomScrollView(
          slivers: <Widget>[
            new AppToolbar(title: "Live Right Now"),
            _buildBody()
          ],
        ),
        drawer: new AppDrawer(onSelect: (Widget page) {}
        )
    );
  }

  _buildBody() {
    return new StoreConnector<_ViewModel>(
        mapper: _mapStateToViewModel,
        widgetBuilder: _buildListView
    );
  }

  Observable<_ViewModel> _mapStateToViewModel(AppStore store) {
    EventCollectionKey key = new EventCollectionKey(
        type: EventCollectionType.LiveRightNow
    );

    return Observable.combineLatest2(
        store.collectionStore[key].observable,
        store.favoritesStore.favorites().observable,
        (collection, favorites) => new _ViewModel(
            store.eventStore.snapshot(collection.eventIds),
            store.eventStore.snapshot(favorites)));
  }

  Widget _buildListView(BuildContext context, _ViewModel model) {
    if (model == null || model.events == null || model.favorites == null) {
      return new SliverFillRemaining(
        child: new Container(
          child: new Center(
            child: new CircularProgressIndicator(),
          ),
        ),
      );
    }
    if (model.events.isEmpty) {
      return new SliverFillRemaining(
        child: new Container(
          child: new Center(
            child: new Text("No live events found."),
          ),
        ),
      );
    }

    return new SectionListView(
        key: new PageStorageKey("lrn"),
        sections: _buildSections(model)
    );
  }

  List<_EventSection> _buildSections(_ViewModel model) {
    List<_EventSection> sections = [];

    for (var event in model.events) {
      var section = _findSection(event.sport, sections);
      section.events.add(event);
    }
    // TODO: sort by groups

    var favorites = new _EventSection()
      ..events = model.favorites
      ..sport = "no-sport"
      ..title = "Favorites";

    sections.insert(0, favorites);

    return sections;
  }

  _EventSection _findSection(String sport, List<_EventSection> sections) {
    for (var section in sections) {
      if (section.sport == sport) {
        return section;
      }
    }

    var section = new _EventSection()
      ..sport = sport
      ..title = sport;
    sections.add(section);
    return section;
  }
}

class _ViewModel {
  final List<Event> events;
  final List<Event> favorites;

  _ViewModel(this.events, this.favorites);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is _ViewModel &&
              runtimeType == other.runtimeType &&
              events == other.events &&
              favorites == other.favorites;

  @override
  int get hashCode =>
      events.hashCode ^
      favorites.hashCode;

}

class _EventSection extends ListSection {
  DateTime date;
  List<Event> events = [];
  String sport;
  bool _initiallyExpanded = false;
  String _title = "";

  @override
  IndexedWidgetBuilder get builder =>
          (context, index) => _buildEventRow(context, events[index], index == events.length - 1);

  @override
  int get count => events.length;

  @override
  bool get initiallyExpanded => _initiallyExpanded;

  set initiallyExpanded(bool value) {
    _initiallyExpanded = value;
  }

  @override
  String get title => _title;

  set title(String value) {
    _title = value;
  }
}

Widget _buildEventRow(BuildContext context, Event event, bool isLast) {
  return new EventListItemWidget(key: Key("lrn-" + event.id.toString()), eventId: event.id, showDivider: !isLast,);
}