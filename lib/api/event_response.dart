import 'package:startup_namer/data/betoffer.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/outcome.dart';


class EventResponse {
  final List<Event> events;
  final List<BetOffer> betoffers;
  final List<Outcome> outcomes;

  EventResponse({this.events, this.betoffers, this.outcomes});
}