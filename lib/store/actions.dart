import 'package:startup_namer/api/event_response.dart';
import 'package:startup_namer/api/offering_api.dart';
import 'package:startup_namer/store/action_type.dart';
import 'package:startup_namer/store/app_store.dart';
import 'package:startup_namer/util/callable.dart';

Callable<Dispatcher> listViewAction({String sport = "all",
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
    var reponse = await fetchLiveOpen();
    dispatcher(ActionType.eventResponse, reponse);
  };
}

Callable<Dispatcher> eventGroups() {
  return (dispatcher) async {
    var reponse = await fetchEventGroups();
    dispatcher(ActionType.eventGroups, reponse);
  };
}

Callable<Dispatcher> highlights() {
  return (dispatcher) async {
    var reponse = await fetchHighlights();
    dispatcher(ActionType.highlightGroups, reponse);
  };
}