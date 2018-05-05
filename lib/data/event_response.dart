import 'package:meta/meta.dart';
import 'package:startup_namer/data/betoffer.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/event_collection_key.dart';
import 'package:startup_namer/data/outcome.dart';


class EventResponse {
  final EventCollectionKey key;
  final List<Event> events;
  final List<BetOffer> betoffers;
  final List<Outcome> outcomes;

  EventResponse({@required this.key, this.events = const [], this.betoffers = const [], this.outcomes= const []}) :
        assert(key != null), assert (events != null), assert(betoffers != null), assert(outcomes != null);
}