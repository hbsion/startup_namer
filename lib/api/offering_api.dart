import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:startup_namer/data/betoffer.dart';
import 'package:startup_namer/data/betoffer_tags.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/event_collection_key.dart';
import 'package:startup_namer/data/event_group.dart';
import 'package:startup_namer/data/event_response.dart';
import 'package:startup_namer/data/live_stats.dart';
import 'package:startup_namer/data/outcome.dart';
import 'package:tuple/tuple.dart';

import 'api_constants.dart';

final HttpClient _client = new HttpClient();
final Logger _log = new Logger("OfferingAPI");

Future<EventResponse> fetchListView({
  String sport = "all",
  String league = "all",
  String region = "all",
  String participant = "all",
  String filter = "matches"}) async {
  var uri = Uri.parse("${ApiConstants.host}/offering/v2018/${ApiConstants
      .offering}/listView/$sport/$region/$league/$participant/$filter.json?lang=${ApiConstants
      .lang}&market=${ApiConstants.market}");
  _log.info(uri);
  var request = await _client.getUrl(uri);
  var response = await request.close();

  var key = EventCollectionKey(
      type: EventCollectionType.listView,
      selector: [sport, region, league, participant, filter]
  );
  if (response.statusCode != 200) {
    _log.warning("Failed to fetch status: ${response.statusCode} uri: $uri");
    return new EventResponse(key: key);
  }

  var body = await response.transform(utf8.decoder).join();
  return compute(_parseListViewResponse, Tuple2(body, key));
}

Future<List<EventResponse>> fetchLandingPage() async {
  var uri = Uri.parse("${ApiConstants.host}/offering/v2018/${ApiConstants
      .offering}/betoffer/landing.json?lang=${ApiConstants.lang}&market=${ApiConstants.market}");
  _log.info(uri);
  var request = await _client.getUrl(uri);
  var response = await request.close();

  if (response.statusCode != 200) {
    _log.warning("Failed to fetch status: ${response.statusCode} uri: $uri");
    return [];
  }

  var body = await response.transform(utf8.decoder).join();
  return compute(_parseLandingResponse, body);
}

Future<EventResponse> fetchLiveOpen() async {
  var uri = Uri.parse("${ApiConstants.host}/offering/v2018/${ApiConstants
      .offering}/event/live/open.json?lang=${ApiConstants.lang}&market=${ApiConstants.market}");
  _log.info(uri);
  var request = await _client.getUrl(uri);
  var response = await request.close();

  var key = EventCollectionKey(
      type: EventCollectionType.liveRightNow
  );
  if (response.statusCode != 200) {
    _log.warning("Failed to fetch status: ${response.statusCode} uri: $uri");
    return new EventResponse(key: key);
  }

  var body = await response.transform(utf8.decoder).join();
  return compute(_parseLiveOpenResponse, Tuple2(body, key));
}

EventResponse _parseLiveOpenResponse(Tuple2<String, EventCollectionKey> tuple) {
  final responseJson = json.decode(tuple.item1);
  List<Event> events = [];
  List<BetOffer> betOffers = [];
  List<Outcome> outcomes = [];
  List<LiveStats> liveStats = [];

  try {
    var eventWithBettoffers = responseJson["liveEvents"];
    for (var eventJson in eventWithBettoffers) {
      var event = Event.fromJson(eventJson["event"]);
      events.add(event);
      var liveData = LiveStats.fromJson(eventJson["liveData"]);
      if (liveData != null) {
        liveStats.add(liveData);
      }

      if (eventJson["mainBetOffer"] != null) {
        var bo = BetOffer.fromJson(eventJson["mainBetOffer"]);
        event.mainBetOfferId = bo.id;
        betOffers.add(bo);
        for (var outcomeJson in eventJson["mainBetOffer"]["outcomes"]) {
          outcomes.add(Outcome.fromJson(outcomeJson));
        }
      }
    }
  } catch (e) {
    _log.severe("Failed to parse json", e);
  }

  return new EventResponse(
      key: tuple.item2,
      events: events,
      betoffers: betOffers,
      outcomes: outcomes,
      liveStats: liveStats
  );
}

List<EventResponse> _parseLandingResponse(String body) {
  final responseJson = json.decode(body);
  List<dynamic> result = responseJson["result"];

  return _parseLandingResult(result).toList();
}

Iterable<EventResponse> _parseLandingResult(List<Map<String, dynamic>>  result) sync * {
  for (var js in result) {
    var key = _convertLandingSectionNameToKey(js["name"]);
    yield _parseEventsWithBetOffers(js, EventCollectionKey(type: key));
  }
}

EventCollectionType _convertLandingSectionNameToKey(String name) {
  switch(name) {
    case "LRN": return EventCollectionType.landingLiveRightNow;
    case "shocker": return EventCollectionType.landingShocker;
    case "nextoff": return EventCollectionType.landingNextOff;
    case "popular": return EventCollectionType.landingPopular;
    case "highlights": return EventCollectionType.landingHighlights;
    case "statingsoon": return EventCollectionType.landingStatingSoon;
    default:
      return EventCollectionType.unknown;
  }
}

EventResponse _parseListViewResponse(Tuple2<String, EventCollectionKey> tuple) {
  final responseJson = json.decode(tuple.item1);
  return _parseEventsWithBetOffers(responseJson, tuple.item2);
}

EventResponse _parseEventsWithBetOffers(Map<String, dynamic> eventsWithBetOffers, EventCollectionKey key) {
  List<Event> events = [];
  List<BetOffer> betOffers = [];
  List<Outcome> outcomes = [];
  List<LiveStats> liveStats = [];

  try {
    var eventWithBetOffers = eventsWithBetOffers["events"];
    for (var eventJson in eventWithBetOffers) {
      var event = Event.fromJson(eventJson["event"]);
      events.add(event);
      var liveData = LiveStats.fromJson(eventJson["liveData"]);
      if (liveData != null) {
        liveStats.add(liveData);
      }

      var eventBo = <BetOffer>[];
      for (var boJson in eventJson["betOffers"]) {
        var bo = BetOffer.fromJson(boJson);
        if (bo.tags.contains(BetOfferTags.main)) {
          event.mainBetOfferId = bo.id;
        }
        eventBo.add(bo);

        for (var outcomeJson in boJson["outcomes"]) {
          outcomes.add(Outcome.fromJson(outcomeJson));
        }
      }
      if (event.mainBetOfferId == null && eventBo.length > 0) {
        event.mainBetOfferId = eventBo[0].id;
      }

      betOffers.addAll(eventBo);
    }
  } catch (e) {
    _log.severe("Failed to parse json", e);
  }

  return new EventResponse(
      key: key,
      events: events,
      betoffers: betOffers,
      outcomes: outcomes,
      liveStats: liveStats
  );
}

Future<EventGroup> fetchEventGroups() async {
  var uri = Uri.parse("${ApiConstants.host}/offering/v2018/${ApiConstants
      .offering}/group.json?lang=${ApiConstants.lang}&market=${ApiConstants.market}");
  _log.info(uri);
  var request = await _client.getUrl(uri);
  var response = await request.close();

  if (response.statusCode != 200) {
    _log.warning("Failed to fetch status: ${response.statusCode} uri: $uri");
    return null;
  }

  var body = await response.transform(utf8.decoder).join();

  return EventGroup.fromJson(json.decode(body)["group"]);
}

Future<List<int>> fetchHighlights() async {
  var uri = Uri.parse("${ApiConstants.host}/offering/v2018/${ApiConstants
      .offering}/group/highlight.json?lang=${ApiConstants.lang}&market=${ApiConstants.market}");
  _log.info(uri);
  var request = await _client.getUrl(uri);
  var response = await request.close();

  if (response.statusCode != 200) {
    _log.warning("Failed to fetch status: ${response.statusCode} uri: $uri");
    return [];
  } else {
    var body = await response.transform(utf8.decoder).join();
    var js = json.decode(body);
    return ((js["groups"] ?? []) as List<dynamic>).map<int>((g) => g["id"]).toList();
  }
}