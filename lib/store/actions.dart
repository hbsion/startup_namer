import 'package:startup_namer/data/event_response.dart';
import 'package:startup_namer/api/offering_api.dart';
import 'package:startup_namer/store/action_type.dart';
import 'package:startup_namer/store/app_store.dart';
import 'package:startup_namer/util/callable.dart';

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

Callable<Dispatcher> landingPage() {
  return (dispatcher) async {
    var response = await fetchLandingPage();
    print(response.toString());
    //dispatcher(ActionType.highlightGroups, response);
  };
}