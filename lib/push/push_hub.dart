import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:startup_namer/data/push/push_message.dart';
import 'package:startup_namer/data/push/push_message_type.dart';
import 'package:startup_namer/push/push_client.dart';
import 'package:startup_namer/store/action_type.dart';
import 'package:startup_namer/store/app_store.dart';


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
    _topics.addAll(topics);
    pushClient.connect();
  }

  void subscribe(String topic) {
    if (!_topics.contains(topic)) {
      _topics.add(topic);
      pushClient.subscribe(topic);
    }
  }

  void unsubscribe(String topic) {
    if (_topics.contains(topic)) {
      _topics.remove(topic);
      pushClient.unsubscribe(topic);
    }
  }

  void _handleClientConnect() {
    _topics.forEach((topic) => pushClient.subscribe(topic));
  }

  void _handlePushMessage(PushMessage msg) {
//    print(msg.toString());
    switch(msg.type) {
      case PushMessageType.oddsUpdate:
        dispatcher(ActionType.oddsUpdate, msg.oddsUpdate);
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

}