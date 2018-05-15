import 'dart:async';

import 'package:svan_play/push/push_client.dart';


void main() {
  var push = new PushClient("wss://e4-push.kambi.com/socket.io/?EIO=3&transport=websocket");
  push.connect();

  new Timer(new Duration(seconds: 10), () => push.close());
}
