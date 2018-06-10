import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:svan_play/api/offering_parser.dart';
import 'package:svan_play/data/betoffer.dart';
import 'package:svan_play/data/betoffer_category.dart';
import 'package:svan_play/data/betoffer_category_response.dart';
import 'package:svan_play/data/event_collection_key.dart';
import 'package:svan_play/data/event_group.dart';
import 'package:svan_play/data/event_response.dart';
import 'package:svan_play/data/live_stats.dart';
import 'package:svan_play/data/search_result.dart';
import 'package:svan_play/data/silk_image.dart';
import 'package:svan_play/data/silk_response.dart';
import 'package:tuple/tuple.dart';

import 'api_constants.dart';

final HttpClient _client = new HttpClient();
final Logger _log = new Logger("OfferingAPI");

Future<EventResponse> fetchListView(
    {String sport = "all",
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

  var key =
      EventCollectionKey(type: EventCollectionType.listView, selector: [sport, region, league, participant, filter]);
  if (response.statusCode != 200) {
    _log.warning("Failed to fetch status: ${response.statusCode} uri: $uri");
    return new EventResponse(key: key);
  }

  var body = await response.transform(utf8.decoder).join();
  return compute(parseListViewResponse, Tuple2(body, key));
}

Future<EventResponse> fetchBetOffers(int eventId) async {
  var uri = Uri.parse("${ApiConstants.host}/offering/v2018/${ApiConstants
      .offering}/betoffer/event/$eventId.json?lang=${ApiConstants
      .lang}&market=${ApiConstants.market}");
  _log.info(uri);
  var request = await _client.getUrl(uri);
  var response = await request.close();

  var key = EventCollectionKey(type: EventCollectionType.eventView);
  if (response.statusCode != 200) {
    _log.warning("Failed to fetch status: ${response.statusCode} uri: $uri");
    return new EventResponse(key: key);
  }

  var body = await response.transform(utf8.decoder).join();
  return compute(parseBetOfferResponse, Tuple2(body, key));
}

Future<BetOffer> fetchPlayerOutcomes(int betOfferId, int outcomeId) async {
  var uri = Uri.parse("${ApiConstants.host}/offering/v2018/${ApiConstants
      .offering}/betoffer/$betOfferId/playeroutcome/$outcomeId.json?lang=${ApiConstants
      .lang}&market=${ApiConstants.market}");
  _log.info(uri);
  var request = await _client.getUrl(uri);
  var response = await request.close();

  var key = EventCollectionKey(type: EventCollectionType.unknown);
  if (response.statusCode != 200) {
    _log.warning("Failed to fetch status: ${response.statusCode} uri: $uri");
    return null;
  }

  var body = await response.transform(utf8.decoder).join();
  var evenResponse = await compute(parseBetOfferResponse, Tuple2(body, key));

  return evenResponse.betoffers.length > 0 ? evenResponse.betoffers[0] : null;
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
  return compute(parseLandingResponse, body);
}

Future<EventResponse> fetchLiveOpen() async {
  var uri = Uri.parse("${ApiConstants.host}/offering/v2018/${ApiConstants
      .offering}/event/live/open.json?lang=${ApiConstants.lang}&market=${ApiConstants.market}");
  _log.info(uri);
  var request = await _client.getUrl(uri);
  var response = await request.close();

  var key = EventCollectionKey(type: EventCollectionType.liveRightNow);
  if (response.statusCode != 200) {
    _log.warning("Failed to fetch status: ${response.statusCode} uri: $uri");
    return new EventResponse(key: key);
  }

  var body = await response.transform(utf8.decoder).join();
  return compute(parseLiveOpenResponse, Tuple2(body, key));
}

Future<LiveStats> fetchLiveStats(int eventId) async {
  var uri = Uri.parse("${ApiConstants.host}/offering/v2018/${ApiConstants
      .offering}/event/$eventId/livedata.json?lang=${ApiConstants.lang}&market=${ApiConstants.market}");
  _log.info(uri);
  var request = await _client.getUrl(uri);
  var response = await request.close();

  if (response.statusCode != 200) {
    _log.warning("Failed to fetch status: ${response.statusCode} uri: $uri");
    return null;
  }

  var body = await response.transform(utf8.decoder).join();
  return compute(parseLiveStatsResponse, body);
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

Future<BetOfferCategoryResponse> fetchBetOfferCategories(String sport, String categoryName) async {
  var uri = Uri.parse("${ApiConstants.host}/offering/v2018/${ApiConstants
      .offering}/category/$categoryName/sport/$sport.json?lang=${ApiConstants.lang}&market=${ApiConstants.market}");
  _log.info(uri);
  var request = await _client.getUrl(uri);
  var response = await request.close();

  if (response.statusCode != 200) {
    _log.warning("Failed to fetch status: ${response.statusCode} uri: $uri");
    return new BetOfferCategoryResponse(sport, categoryName, []);
  }

  String body = await response.transform(utf8.decoder).join();
  List<BetOfferCategory> categories = await compute(parseBetOfferCategories, body);

  return new BetOfferCategoryResponse(sport, categoryName, categories);
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

Future<SearchResult> doSearch(String term) async {
  var uri = Uri.parse("${ApiConstants.host}/offering/v2018/${ApiConstants
      .offering}/term/search.json?lang=${ApiConstants.lang}&market=${ApiConstants.market}&term=$term");
  _log.info(uri);
  var request = await _client.getUrl(uri);
  var response = await request.close();

  if (response.statusCode != 200) {
    _log.warning("Failed to fetch status: ${response.statusCode} uri: $uri");
    return null;
  } else {
    var body = await response.transform(utf8.decoder).join();
    var js = json.decode(body);
    return SearchResult.fromJson(js);
  }
}

Future<SilkResponse> fetchSilks(int eventId) async {
  var uri = Uri.parse("${ApiConstants.host}/offering/v2018/${ApiConstants.offering}/event/icon.json?id=$eventId");
  _log.info(uri);
  var request = await _client.getUrl(uri);
  var response = await request.close();

  if (response.statusCode != 200) {
    _log.warning("Failed to fetch status: ${response.statusCode} uri: $uri");
    return new SilkResponse(eventId, []);
  } else {
    var body = await response.transform(utf8.decoder).join();
    var js = json.decode(body);
    List<SilkImage> silks = [];

    List<dynamic> events = js["events"];
    Map<String, dynamic> event = events.length > 0 ? events[0] : null;
    if (event != null) {
      List<dynamic> participants = event["participants"];
      for (Map<String, dynamic> p in participants) {
        int participantId = p["participantId"];
        var extended = p["extended"];
        if (extended != null) {
          String icon = extended["icon"];
          silks.add(new SilkImage(eventId, participantId, icon != null ? base64.decode(icon) : null));
        }
      }
    }

    return new SilkResponse(eventId, silks);
  }
}
