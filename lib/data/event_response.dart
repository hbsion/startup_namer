import 'package:meta/meta.dart';
import 'package:svan_play/data/betoffer.dart';
import 'package:svan_play/data/event.dart';
import 'package:svan_play/data/event_collection_key.dart';
import 'package:svan_play/data/live_stats.dart';
import 'package:svan_play/data/outcome.dart';

class EventResponse {
  final EventCollectionKey key;
  final List<Event> events;
  final List<BetOffer> betoffers;
  final List<Outcome> outcomes;
  final List<LiveStats> liveStats;

  EventResponse({
    @required this.key,
    this.events = const [],
    this.betoffers = const [],
    this.outcomes = const [],
    this.liveStats = const []
  })
      :
        assert(key != null),
        assert (events != null),
        assert(betoffers != null),
        assert(outcomes != null);
}