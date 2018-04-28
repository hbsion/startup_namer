import 'dart:_http';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:startup_namer/data/betoffer.dart';
import 'package:startup_namer/data/betoffer_tags.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/event_collection_key.dart';
import 'package:startup_namer/data/outcome.dart';

import 'api_constants.dart';
import 'event_response.dart';

HttpClient _client = new HttpClient();

Future<EventResponse> fetchListView({
  String sport = "all",
  String league = "all",
  String region = "all",
  String participant = "all",
  String filter = "matches"}) async {
  var uri = Uri.parse("${ApiConstants.host}/offering/v2018/${ApiConstants
      .offering}/listView/$sport/$region/$league/$participant/$filter.json?lang=${ApiConstants
      .lang}&market=${ApiConstants.market}&categoryGroup=COMBINED&displayDefault=true");
  print(uri);
  var request = await _client.getUrl(uri);
  var response = await request.close();
  var body = await response.transform(utf8.decoder).join();

  return parseEventResponse(body, sport, region, league, participant, filter);
}

EventResponse parseEventResponse(String body, String sport, String region, String league,
    String participant, String filter) {

  final responseJson = json.decode(body);
  List<Event> events = [];
  List<BetOffer> betOffers = [];
  List<Outcome> outcomes = [];

  var eventWithBettoffers = responseJson["events"];
  for (var eventJson in eventWithBettoffers) {
    var event = Event.fromJson(eventJson["event"]);
    events.add(event);

    for (var boJson in eventJson["betOffers"]) {
      var bo = BetOffer.fromJson(boJson);
      if (bo.tags.contains(BetOfferTags.main)) {
        event.mainBetOfferId = bo.id;
      }
      betOffers.add(bo);

      for (var outcomeJson in boJson["outcomes"]) {
        outcomes.add(Outcome.fromJson(outcomeJson));
      }
    }
  }

  return new EventResponse(
      key: new EventCollectionKey(
          type: EventCollectionType.ListView, selector: [sport, region, league, participant, filter]),
      events: events,
      betoffers: betOffers,
      outcomes: outcomes
  );
}