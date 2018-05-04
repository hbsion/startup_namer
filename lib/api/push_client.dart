import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/data/push/push_message.dart';
import 'package:web_socket_channel/io.dart';

class PushClient {
  final RegExp _packetExp = new RegExp("^(\\d+)(.*)\$");
  final String url;
  final PublishSubject<PushMessage> _subject = new PublishSubject<PushMessage>();

  IOWebSocketChannel _channel;
  Timer _heartbeat;

  PushClient(this.url);

  Observable<PushMessage> get observable => _subject.observable;

  void connect() {
    _channel = new IOWebSocketChannel.connect(url);
    _channel.stream.listen(_onData, onDone: _onDone, onError: _onError);
    _heartbeat = new Timer.periodic(
        new Duration(seconds: 5), (_) => _channel.sink.add("2"));
  }

  void subscribe(String topic) {
    _channel.sink.add('42["subscribe",{"topic":"$topic.json"}]');
  }

  void unsubscribe(String topic) {
    _channel.sink.add('42["unsubscribe",{"topic":"$topic.json"}]');
  }

  void close() {
    _channel.sink.close();
    _heartbeat.cancel();
    _subject.close();
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
        subscribe("ub.ev");
        break;
      case 42:
        //print("Message/Event with payload: $payload");
        _handleMessage(payload);
        break;
      default:
        print("Unknown message type $type with payload: '$payload'");
    }
  }

  void _handleMessage(String payload) {
    List<String> data = json.decode(payload);

    if (data[0] == "message") {
      List<Map<String, dynamic>> batch = json.decode(data[1]);
      batch.map((x) => new PushMessage.fromJson(x)).forEach((pm) => _subject.add(pm));
    }
  }
}
