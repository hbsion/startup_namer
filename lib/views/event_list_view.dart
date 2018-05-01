import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/event_collection.dart';
import 'package:startup_namer/data/event_collection_key.dart';
import 'package:startup_namer/data/event_state.dart';
import 'package:startup_namer/store/actions.dart';
import 'package:startup_namer/store/app_store.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/util/dates.dart';
import 'package:startup_namer/util/flowable.dart';
import 'package:startup_namer/widgets/event_list_item_widget.dart';
import 'package:startup_namer/widgets/section_list_view.dart';

class EventListView extends StatelessWidget {
  final String sport;
  final String league;
  final String region;
  final String participant;
  final String filter;

  const EventListView({Key key, this.sport, this.league, this.region, this.participant, this.filter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<_ViewModel>(
        mapper: _mapStateToViewModel,
        snapshot: _mapStateToSnapshot,
        action: listViewAction(sport: sport,
            region: region,
            league: league,
            participant: participant,
            filter: filter),
        widgetBuilder: _build
    );
  }

  Observable<_ViewModel> _mapStateToViewModel(AppStore store) {
    return _collection(store).observable.map((collection) {
      return new _ViewModel(store.eventStore.snapshot(collection.eventIds));
    });
  }

  _ViewModel _mapStateToSnapshot(AppStore store) {
    var snapshot = _collection(store);
    if (snapshot.last != null) {
      return new _ViewModel(store.eventStore.snapshot(snapshot.last.eventIds));
    }
    return null;
  }

  SnapshotObservable<EventCollection> _collection(AppStore store) {
    EventCollectionKey key = new EventCollectionKey(
        type: EventCollectionType.ListView,
        selector: [sport, region, league, participant, filter]
    );
    return store.collectionStore[key];
  }

  Widget _build(BuildContext context, _ViewModel model) {
    if (model == null) {
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
            child: new Text("No $filter found."),
          ),
        ),
      );
    }

    return new SectionListView(
        key: new PageStorageKey(filter),
        sections: _buildSections(model)
    );
  }

  List<_EventSection> _buildSections(_ViewModel viewModel) {
    _GroupBy groupBy;
    _SortSectionsBy sortSectionsBy;
    _SortEventsBy sortEventsBy = _sortEventsByDate;

    if (filter == "starting-soon") {
      groupBy = _groupByHour;
      sortSectionsBy = _sortByDate;
    } else if (league == "all") {
      groupBy = _groupByLeague;
      sortSectionsBy = _sortByLeague;
    } else {
      groupBy = _groupByDate;
      sortSectionsBy = _sortByDate;
    }

    var sections = _groupAndSortEvents(
        viewModel.events,
        groupBy,
        sortSectionsBy,
        sortEventsBy
    );

    if (filter == "starting-soon" && sections.length > 0) {
      sections[0].title = "Next Off";
    }
    return sections;
  }

  List<_EventSection> _groupAndSortEvents(List<Event> events,
      _GroupBy groupBy,
      _SortSectionsBy sortBy,
      _SortEventsBy sortEventsBy) {
    List<_EventSection> sections = [];
    events.forEach((e) => groupBy(e, sections));
    sections.sort(sortBy);
    sections.forEach((section) => section.events.sort(sortEventsBy));

    // Initially exapnd at least 10 rows
    int visibleItems = 0;
    for (var section in sections) {
      visibleItems += section.count;
      section.initiallyExpanded = true;
      if (visibleItems > 5) break;
    }

    return sections;
  }

  void _groupByLeague(Event event, List<_EventSection> sections) {
    var inPlay = event.state == EventState.STARTED;

    var dt = date(event.start);
    _EventSection selected;

    String league;

    if (event.path.length == 3) {
      league = event.path[1].name + " / " + event.path[2].name;
    } else if (event.path.length == 2) {
      league = event.path[1].name;
    } else {
      league = event.group;
    }
    for (var section in sections) {
      if (section.live && inPlay) {
        selected = section;
      } else if (!section.live && !inPlay && section.league == league) {
        selected = section;
      }
    }
    if (selected == null) {
      selected = new _EventSection()
        ..live = inPlay
        ..date = dt
        ..league = league
        ..title = inPlay ? "LIVE" : league
        ..titleStyle = inPlay ? new TextStyle(color: Colors.red, fontWeight: FontWeight.w700) : null;

      sections.add(selected);
    }

    selected.events.add(event);
  }

  void _groupByDate(Event event, List<_EventSection> sections) {
    var inPlay = event.state == EventState.STARTED;

    var dt = date(event.start);
    _EventSection selected;
    for (var section in sections) {
      if (inPlay && section.live) {
        selected = section;
        break;
      } else if (!inPlay && !section.live && section.date == dt) {
        selected = section;
        break;
      }
    }

    if (selected == null) {
      selected = new _EventSection()
        ..live = inPlay
        ..date = dt
        ..league = ""
        ..title = inPlay ? "LIVE" : prettyDate(dt)
        ..titleStyle = inPlay ? new TextStyle(color: Colors.red, fontWeight: FontWeight.w700) : null;
      sections.add(selected);
    }

    selected.events.add(event);
  }

  void _groupByHour(Event event, List<_EventSection> sections) {
    var timeOfDay = withHours(event.start);

    _EventSection selected;
    for (var section in sections) {
      if (section.date == timeOfDay) {
        selected = section;
        break;
      }
    }

    if (selected == null) {
      selected = new _EventSection()
        ..live = false
        ..date = timeOfDay
        ..title = hourRange(timeOfDay.toLocal());
      sections.add(selected);
    }

    selected.events.add(event);
  }

  int _sortByDate(_EventSection a, _EventSection b) {
    if (a.live) return -1;
    if (b.live) return 1;

    return a.date.compareTo(b.date);
  }

  int _sortByLeague(_EventSection a, _EventSection b) {
    if (a.live) return -1;
    if (b.live) return 1;

    return a.league.compareTo(b.league);
  }

  int _sortEventsByDate(Event a, Event b) => a.start.compareTo(b.start);
}

class _ViewModel {
  final List<Event> events;

  _ViewModel(this.events);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is _ViewModel &&
              runtimeType == other.runtimeType &&
              new DeepCollectionEquality().equals(events, other.events);

  @override
  int get hashCode => events.hashCode;
}

typedef _GroupBy = void Function(Event event, List<_EventSection> sections);
typedef _SortSectionsBy = int Function(_EventSection a, _EventSection b);
typedef _SortEventsBy = int Function(Event a, Event b);

class _EventSection extends ListSection {
  DateTime date;
  List<Event> events = [];
  bool live;
  String league;
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
  return new EventListItemWidget(key: Key(event.id.toString()), eventId: event.id, showDivider: !isLast,);
}
