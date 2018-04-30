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
import 'package:startup_namer/data/outcome.dart';
import 'package:tuple/tuple.dart';

import 'api_constants.dart';
import 'event_response.dart';

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
      type: EventCollectionType.ListView,
      selector: [sport, region, league, participant, filter]
  );
  if (response.statusCode != 200) {
    _log.warning("Failed to fetch status: ${response.statusCode} uri: $uri");
    return new EventResponse(key: key);
  }

  var body = await response.transform(utf8.decoder).join();
  return compute(_parseListViewResponse, Tuple2(body, key));
}

Future<EventResponse> fetchLiveOpen() async {
  var uri = Uri.parse("${ApiConstants.host}/offering/v2018/${ApiConstants
      .offering}/event/live/open.json?lang=${ApiConstants.lang}&market=${ApiConstants.market}");
  _log.info(uri);
  var request = await _client.getUrl(uri);
  var response = await request.close();

  var key = EventCollectionKey(
      type: EventCollectionType.LiveRightNow
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

  try {
    var eventWithBettoffers = responseJson["liveEvents"];
    for (var eventJson in eventWithBettoffers) {
      var event = Event.fromJson(eventJson["event"]);
      events.add(event);

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
      outcomes: outcomes
  );
}

EventResponse _parseListViewResponse(Tuple2<String, EventCollectionKey> tuple) {
  final responseJson = json.decode(tuple.item1);
  List<Event> events = [];
  List<BetOffer> betOffers = [];
  List<Outcome> outcomes = [];

  try {
    var eventWithBettoffers = responseJson["events"];
    for (var eventJson in eventWithBettoffers) {
      var event = Event.fromJson(eventJson["event"]);
      events.add(event);

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
      key: tuple.item2,
      events: events,
      betoffers: betOffers,
      outcomes: outcomes
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