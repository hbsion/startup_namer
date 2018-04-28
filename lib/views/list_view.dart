import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/event_collection.dart';
import 'package:startup_namer/data/event_collection_key.dart';
import 'package:startup_namer/data/event_state.dart';
import 'package:startup_namer/store/actions.dart';
import 'package:startup_namer/store/app_store.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/util/dates.dart';
import 'package:startup_namer/widgets/event_list_widget.dart';
import 'package:startup_namer/widgets/section_list_view.dart';

class SportView extends StatelessWidget {
  final String sport;
  final String league;
  final String region;
  final String participant;
  final String filter;

  const SportView({Key key, this.sport, this.league, this.region, this.participant, this.filter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EventCollectionKey key = new EventCollectionKey(
        type: EventCollectionType.ListView,
        selector: [sport, region, league, participant, filter]
    );
    return new StoreConnector<EventCollection>(
        mapper: (store) => store.collectionStore.collection(key),
        action: listViewAction(sport: sport,
            region: region,
            league: league,
            participant: participant,
            filter: filter),
        builder: _build
    );
  }

  Widget _build(BuildContext context, EventCollection model, AppStore store) {
    if (model == null) {
      return new SliverFillRemaining(
        child: new Container(
          child: new Center(
            child: new CupertinoActivityIndicator(),
          ),
        ),
      );
    }
    return new SectionListView(
        key: new PageStorageKey(filter),
        sections: _buildData(model, store)
    );
  }

  List<_SportSection> _buildData(EventCollection model, AppStore store) {
    bool byLeague = league == "all";
    var sections = _groupAndSortEvents(
        store.eventStore.snapshot(model.eventIds),
        byLeague ? _groupByLeague : _groupByDate,
        byLeague ? _sortByLeague : _sortByDate
    );

    return sections;
  }

  List<_SportSection> _groupAndSortEvents(List<Event> events, GroupBy groupBy, SortBy sortBy) {
    List<_SportSection> sections = [];
    events.forEach((e) => groupBy(e, sections));
    sections.sort(sortBy);

    return sections;
  }

  void _groupByLeague(Event event, List<_SportSection> sections) {
    var inPlay = event.state == EventState.STARTED;

    var dt = date(event.start);
    _SportSection selected;

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
      selected = new _SportSection()
        ..live = inPlay
        ..date = dt
        ..league = league
        ..title = league;
      sections.add(selected);
    }

    selected.events.add(event);
  }

  void _groupByDate(Event event, List<_SportSection> sections) {
    var inPlay = event.state == EventState.STARTED;

    var dt = date(event.start);
    _SportSection selected;
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
      selected = new _SportSection()
        ..live = inPlay
        ..date = dt
        ..league = ""
        ..title = prettyDate(dt);
      sections.add(selected);
    }

    selected.events.add(event);
  }

  int _sortByDate(_SportSection a, _SportSection b) {
    if (a.live) return -1;
    if (b.live) return 1;

    return a.date.compareTo(b.date);
  }

  int _sortByLeague(_SportSection a, _SportSection b) {
    if (a.live) return -1;
    if (b.live) return 1;

    return a.league.compareTo(b.league);
  }
}

typedef GroupBy = void Function(Event event, List<_SportSection> sections);
typedef SortBy = int Function(_SportSection a, _SportSection b);

class _SportSection extends ListSection {
  DateTime date;
  List<Event> events = [];
  bool live;
  String league;
  bool _initiallyExpanded = false;
  String _title = "";

  @override
  IndexedWidgetBuilder get builder => (context, index) => _buildEventRow(context, events[index]);

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

Widget _buildEventRow(BuildContext context, Event event) {
  return new EventListItemWidget(key: Key(event.id.toString()), event: event,);
}
