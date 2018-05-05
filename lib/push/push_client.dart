import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/data/push/push_message.dart';
import 'package:web_socket_channel/io.dart';

class PushClient {
  final RegExp _packetExp = new RegExp("^(\\d+)(.*)\$");
  final String url;
  final PublishSubject<PushMessage> _messagePublisher = new PublishSubject<PushMessage>();
  final PublishSubject<void> _connectPublisher = new PublishSubject<void>();

  IOWebSocketChannel _channel;
  Timer _heartbeat;

  PushClient(this.url);

  Observable<PushMessage> get messageStream => _messagePublisher.observable;

  Observable<void> get connectStream => _connectPublisher.observable;

  void connect() {
    _channel = new IOWebSocketChannel.connect(url);
    _channel.stream.listen(_onData, onDone: _onDone, onError: _onError);
    _heartbeat = new Timer.periodic(
        new Duration(seconds: 5), (_) => _channel.sink.add("2"));
  }

  void pause() {
    _disconnect();
  }

  void resume() {
    connect();
  }

  void subscribe(String topic) {
    _channel.sink.add('42["subscribe",{"topic":"$topic.json"}]');
  }

  void unsubscribe(String topic) {
    _channel.sink.add('42["unsubscribe",{"topic":"$topic.json"}]');
  }

  void close() {
    _disconnect();
    _messagePublisher.close();
  }

  void _disconnect() {
    _channel.sink.close();
    _heartbeat.cancel();
  }

  void _onData(event) {
    var matches = _packetExp.allMatches(event.toString());
    for (var match in matches) {
      _handlePacket(int.parse(match.group(1)), match.group(2));
    }
  }

  void _onDone() {
    print("onDone");
  }

  void _onError(error) {
    print("onError: " + error.toString());
  }

  void _handlePacket(int type, String payload) {
    switch (type) {
      case 0:
        print("Open with payload: $payload");
        break;
      case 3:
        print("pong");
        break;
      case 40:
        print("Message/Connect with payload: $payload");
        _connectPublisher.add(null);
        break;
      case 42:
        _handleMessage(payload);
        break;
      default:
        print("Unknown message type $type with payload: '$payload'");
    }
  }

  void _handleMessage(String payload) {
    List<dynamic> data = json.decode(payload);

    if (data[0] == "message") {
      List<dynamic> batch = json.decode(data[1]);
      batch.map((x) => new PushMessage.fromJson(x))
          .where((x) => x != null)
          .forEach((pm) => _messagePublisher.add(pm));
    }
  }
}
