import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:startup_namer/data/betoffer.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/outcome.dart';

import 'api_constants.dart';
import 'event_response.dart';


Future<EventResponse> fetchListView({
  String sport = "all",
  String league = "all",
  String region = "all",
  String participant = "all",
  String filter = "matches"}) async {

  var url = "${ApiConstants.host}/offering/v2018/${ApiConstants
      .offering}/listView/$sport/$region/$league/$participant/$filter.json?lang=${ApiConstants
      .lang}&market=${ApiConstants.market}&categoryGroup=COMBINED&displayDefault=true";
  print(url);
  var response = await http.get(url);
  final responseJson = json.decode(response.body);

  List<Event> events = [];
  List<BetOffer> betOffers = [];
  List<Outcome> outcomes = [];

  var eventWithBettoffers = responseJson["events"];
  for (var eventJson in eventWithBettoffers) {
    events.add(Event.fromJson(eventJson["event"]));
  }

  return new EventResponse(
    events: events,
    betoffers: betOffers,
    outcomes: outcomes
  );
}