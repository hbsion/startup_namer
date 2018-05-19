import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:svan_play/api/api_constants.dart';
import 'package:svan_play/data/push/push_message.dart';
import 'package:svan_play/data/push/push_message_type.dart';
import 'package:svan_play/push/push_client.dart';
import 'package:svan_play/store/action_type.dart';
import 'package:svan_play/store/app_store.dart';

class PushHub extends WidgetsBindingObserver {
  final PushClient pushClient;
  final Dispatcher dispatcher;
  final Set<String> _topics = new HashSet();
  AppLifecycleState _appState = AppLifecycleState.resumed;

  PushHub(this.pushClient, this.dispatcher) {
    pushClient.messageStream.listen(_handlePushMessage);
    pushClient.connectStream.listen((_) => _handleClientConnect());
  }

  void connect(List<String> topics) {
    _topics.addAll(topics.map(_composeTopic));
    pushClient.connect();
  }

  void subscribe(List<String> topics) {
    for (var topic in topics) {
      topic = _composeTopic(topic);
      if (!_topics.contains(topic)) {
        _topics.add(topic);
        pushClient.subscribe(topic);
      }
    }
  }

  void unsubscribe(List<String> topics) {
    for (var topic in topics) {
      topic = _composeTopic(topic);
      if (_topics.contains(topic)) {
        _topics.remove(topic);
        pushClient.unsubscribe(topic);
      }
    }
  }

  void _handleClientConnect() {
    _topics.forEach((topic) => pushClient.subscribe(topic));
  }

  void _handlePushMessage(PushMessage msg) {
    //print(msg.toString());
    switch (msg.type) {
      case PushMessageType.betOfferStatusUpdate:
        dispatcher(ActionType.betOfferStatusUpdate, msg.betOfferStatusUpdate);
        break;
      case PushMessageType.betOfferAdded:
        dispatcher(ActionType.betOfferAdded, msg.betOfferAdded);
        break;
      case PushMessageType.betOfferRemoved:
        dispatcher(ActionType.betOfferRemoved, msg.betOfferRemoved);
        break;
      case PushMessageType.oddsUpdate:
        dispatcher(ActionType.oddsUpdate, msg.oddsUpdate);
        break;
      case PushMessageType.matchClockUpdate:
        dispatcher(ActionType.matchClockUpdate, msg.matchClockUpdate);
        break;
      case PushMessageType.scoreUpdate:
        dispatcher(ActionType.scoreUpdate, msg.scoreUpdate);
        break;
      case PushMessageType.eventStatsUpdate:
        dispatcher(ActionType.eventStatsUpdate, msg.eventStatsUpdate);
        break;
      default:
        break;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_appState == AppLifecycleState.resumed && state == AppLifecycleState.paused) {
      pushClient.pause();
      _appState = AppLifecycleState.paused;
    } else if (_appState == AppLifecycleState.paused && state == AppLifecycleState.resumed) {
      pushClient.resume();
      _appState = AppLifecycleState.resumed;
    }
  }

  String _composeTopic(String topic) => '${ApiConstants.pushVersion}.${ApiConstants.offering}.$topic';
}
