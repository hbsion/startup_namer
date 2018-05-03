import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/app_drawer.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/event_collection_key.dart';
import 'package:startup_namer/data/event_group.dart';
import 'package:startup_namer/store/app_store.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/widgets/app_toolbar.dart';
import 'package:startup_namer/widgets/event_list_item_widget.dart';
import 'package:startup_namer/widgets/platform_circular_progress_indicator.dart';
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
        store.favoritesStore
            .favorites()
            .observable,
            (collection, favorites) =>
        new _ViewModel(
            store.eventStore.snapshot(collection.eventIds),
            store.eventStore.snapshot(favorites),
            store.groupStore.groupById
        ));
  }

  Widget _buildListView(BuildContext context, _ViewModel model) {
    if (model == null || model.events == null || model.favorites == null) {
      return new SliverFillRemaining(
        child: new Container(
          child: new Center(
            child: new PlatformCircularProgressIndicator(),
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
        sections: _buildSections(context, model)
    );
  }

  List<_EventSection> _buildSections(BuildContext context, _ViewModel model) {
    List<_EventSection> sections = [];

    for (var event in model.events) {
      var section = _findSection(context, model, event, sections);
      section.events.add(event);
    }

    sections.sort((a, b) {
       var sortOrder = a.sortOrder.compareTo(b.sortOrder);
       if (sortOrder == 0) {
         sortOrder = a.title.compareTo(b.title);
       }
       return sortOrder;
    });

    var favorites = new _EventSection()
      ..leading = new Container(
          padding: EdgeInsets.only(right: 4.0), child: new Icon(Icons.star, color: Colors.orangeAccent))
      ..events = model.favorites
      ..sport = "no-sport"
      ..title = "Favorites";

    sections.insert(0, favorites);

    int expanded = 0;
    for (var section in sections) {
      section.initiallyExpanded = true;
      expanded += section.count;
      if (expanded > 5)
        break;
    }

    return sections;
  }

  _EventSection _findSection(BuildContext context, _ViewModel model, Event event, List<_EventSection> sections) {
    for (var section in sections) {
      if (section.sport == event.sport) {
        return section;
      }
    }

    var eventGroup = EventGroup.resolveRoot(model.eventGroupResolver(event.groupId));
    var section = new _EventSection()
      ..leading = new Container(padding: EdgeInsets.only(right: 4.0), child: new Text("Live", style: Theme
          .of(context)
          .textTheme
          .subhead
          .merge(new TextStyle(color: Colors.red, fontStyle: FontStyle.italic))))
      ..sport = event.sport
      ..title = eventGroup.name ?? event.sport
      ..sortOrder = eventGroup.sortOrder
    ;
    sections.add(section);
    return section;
  }
}

typedef EventGroup EventGroupResolver(int id);

class _ViewModel {
  final List<Event> events;
  final List<Event> favorites;
  final EventGroupResolver eventGroupResolver;

  _ViewModel(this.events, this.favorites, this.eventGroupResolver);

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
  int sortOrder = 0;

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