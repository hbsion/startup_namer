import 'package:svan_play/data/event_collection_key.dart';
import 'package:svan_play/data/event_response.dart';
import 'package:svan_play/api/offering_api.dart';
import 'package:svan_play/store/action_type.dart';
import 'package:svan_play/store/app_store.dart';
import 'package:svan_play/util/callable.dart';

Callable<Dispatcher> listViewAction({
  String sport = "all",
  String league = "all",
  String region = "all",
  String participant = "all",
  String filter = "matches"}) {
  return (Dispatcher dispatcher) async {
    EventResponse resp = await fetchListView(
        sport: sport,
        region: region,
        league: league,
        participant: participant,
        filter: filter);
    dispatcher(ActionType.eventResponse, resp);
  };
}

Callable<Dispatcher> liveOpen() {
  return (dispatcher) async {
    var response = await fetchLiveOpen();
    dispatcher(ActionType.eventResponse, response);
  };
}

Callable<Dispatcher> eventGroups() {
  return (dispatcher) async {
    var response = await fetchEventGroups();
    dispatcher(ActionType.eventGroups, response);
  };
}

Callable<Dispatcher> highlights() {
  return (dispatcher) async {
    var response = await fetchHighlights();
    dispatcher(ActionType.highlightGroups, response);
  };
}

Callable<Dispatcher> silks(int eventId) {
  return (dispatcher) async {
    var response = await fetchSilks(eventId);
    dispatcher(ActionType.silkResponse, response);
  };
}

Callable<Dispatcher> betOffers(int eventId) {
  return (dispatcher) async {
    var response = await fetchBetOffers(eventId);
    dispatcher(ActionType.betOfferResponse, response);
  };
}

Callable<Dispatcher> categoryGroup(int eventGroupId, String categoryName) {
  return (dispatcher) async {
    var response = await fetchBetOfferCategories(eventGroupId, categoryName);
    dispatcher(ActionType.betOfferResponse, response);
  };
}

Callable<Dispatcher> landingPage() {
  return (dispatcher) async {
    var response = await fetchLandingPage();
    for (var events in response.where((e) => e.key.type != EventCollectionType.unknown)) {
      dispatcher(ActionType.eventResponse, events);
    }
  };
}