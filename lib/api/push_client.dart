import 'dart:async';
import 'dart:collection';

import 'package:startup_namer/util/callable.dart';
import 'package:web_socket_channel/io.dart';

class PushClient {
  final String url;
  IOWebSocketChannel _channel;
  Timer _heartbeat;
  final Callable<PushClient> onConnected;
  final Set<String> topics = new HashSet();
  Timer _reconnectTimer;
  bool _closingDown = false;

  PushClient({this.url, this.onConnected});

  void connect() {
    _channel = new IOWebSocketChannel.connect(
        'ws://localhost:15017/socket.io/?EIO=3&transport=websocket');
//        'wss://e4-push.kambi.com/socket.io/?EIO=3&transport=websocket');
    _channel.stream.listen(_onData, onDone: _onDone, onError: _onError);
    _heartbeat = new Timer.periodic(
        new Duration(seconds: 5), (_) => _channel.sink.add("2"));
  }

  void _onData(event) {
    RegExp exp = new RegExp("^(\\d+)(.*)\$");
    var matches = exp.allMatches(event.toString());
    for (var match in matches) {
      _processMessage(int.parse(match.group(1)), match.group(2));
    }
  }

  void _onDone() {
    print("onDone, closingDown: " + _closingDown.toString());
    if (!_closingDown) {
      _reconnect();
    }
  }

  _onError(error) {
    print("onError: " + error.toString());
  }

  void _processMessage(int type, String payload) {
    switch (type) {
      case 0:
        print("Open with payload: $payload");
        break;
      case 3:
        print("pong");
        break;
      case 40:
        print("Message/Connect with payload: $payload");
        if (onConnected != null) {
          onConnected(this);
        }
        break;
      case 42:
        print("Message/Event with payload: $payload");
        break;
      default:
        print("Unknown message type $type with payload: '$payload'");
    }
  }

  void subscribe(String topic) {
    _channel.sink.add('42["subscribe",{"topic":"$topic.json"}]');
  }

  void unsubscribe(String topic) {
    _channel.sink.add('42["unsubscribe",{"topic":"$topic.json"}]');
  }

  void close() {
    _closingDown = true;
    _reconnectTimer?.cancel();
    _channel.sink.close();
    _heartbeat.cancel();
  }

  void _reconnect() {
    new Timer(new Duration(seconds: 5), () {
      try {
        connect();
      } catch (e) {
        print(e);
      }
    });
  }
}
