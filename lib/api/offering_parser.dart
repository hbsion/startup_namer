import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:svan_play/data/betoffer.dart';
import 'package:svan_play/data/betoffer_category.dart';
import 'package:svan_play/data/betoffer_tags.dart';
import 'package:svan_play/data/event.dart';
import 'package:svan_play/data/event_collection_key.dart';
import 'package:svan_play/data/event_response.dart';
import 'package:svan_play/data/live_stats.dart';
import 'package:svan_play/data/outcome.dart';
import 'package:tuple/tuple.dart';

final Logger _log = new Logger("OfferingParser");

EventResponse parseListViewResponse(Tuple2<String, EventCollectionKey> tuple) {
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
        eventBo.add(bo);

        for (var outcomeJson in boJson["outcomes"]) {
          outcomes.add(Outcome.fromJson(outcomeJson));
        }
      }
      event.mainBetOfferId = _determinMainBetOffer(eventBo);
      betOffers.addAll(eventBo);
    }
  } catch (e) {
    _log.severe("Failed to parse json", e);
  }

  return new EventResponse(key: key, events: events, betoffers: betOffers, outcomes: outcomes, liveStats: liveStats);
}

EventResponse parseBetOfferResponse(Tuple2<String, EventCollectionKey> tuple) {
  final responseJson = json.decode(tuple.item1);
  List<Event> events = [];
  List<BetOffer> betOffers = [];
  List<Outcome> outcomes = [];

  for (var boJson in responseJson["betOffers"]) {
    var bo = BetOffer.fromJson(boJson);
    betOffers.add(bo);

    for (var outcomeJson in boJson["outcomes"]) {
      outcomes.add(Outcome.fromJson(outcomeJson));
    }
  }

  for (var eventJson in responseJson["events"]) {
    var event = Event.fromJson(eventJson);
    event.mainBetOfferId = _determinMainBetOffer(betOffers);
    events.add(event);
  }

  return new EventResponse(key: tuple.item2, events: events, betoffers: betOffers, outcomes: outcomes);
}

LiveStats parseLiveStatsResponse(String body) {
  final responseJson = json.decode(body);
  return LiveStats.fromJson(responseJson["liveData"]);
}

EventResponse parseLiveOpenResponse(Tuple2<String, EventCollectionKey> tuple) {
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
      key: tuple.item2, events: events, betoffers: betOffers, outcomes: outcomes, liveStats: liveStats);
}

List<EventResponse> parseLandingResponse(String body) {
  final responseJson = json.decode(body);
  List<dynamic> result = responseJson["result"];

  return parseLandingResult(result).toList();
}

Iterable<EventResponse> parseLandingResult(List<dynamic> result) sync* {
  for (var js in result) {
    var key = _convertLandingSectionNameToKey(js["name"]);
    yield _parseEventsWithBetOffers(js, EventCollectionKey(type: key));
  }
}

List<BetOfferCategory> parseBetOfferCategories(String body) {
  var categories = <BetOfferCategory>[];
  var decoded = json.decode(body);
  for (var group in decoded["categoryGroups"]) {
    for (var category in group["categories"]) {
      categories.add(new BetOfferCategory.fromJson(category));
    }
  }
  return categories;
}

EventCollectionType _convertLandingSectionNameToKey(String name) {
  switch (name) {
    case "LRN":
      return EventCollectionType.landingLiveRightNow;
    case "shocker":
      return EventCollectionType.landingShocker;
    case "nextoff":
      return EventCollectionType.landingNextOff;
    case "popular":
      return EventCollectionType.landingPopular;
    case "highlights":
      return EventCollectionType.landingHighlights;
    case "startingsoon":
      return EventCollectionType.landingStartingSoon;
    default:
      return EventCollectionType.unknown;
  }
}

int _determinMainBetOffer(List<BetOffer> betOffers) {
  var main = betOffers.where((bo) => bo.tags.contains(BetOfferTags.main)).toList();
  if (main.length > 1) {
    var mainExSP = main.where((bo) => !bo.tags.contains(BetOfferTags.startingPrice)).first;
    if (mainExSP != null) {
      return mainExSP.id;
    } else {
      return main[0].id;
    }
  }
  if (main.length == 1) {
    return main[0].id;
  }
  if (main.length == 0 && betOffers.length > 0) {
    return betOffers[0].id;
  }

  return null;
}
