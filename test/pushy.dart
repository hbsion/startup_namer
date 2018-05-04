import 'dart:async';

import 'package:startup_namer/api/push_client.dart';

void main() {
  var push = new PushClient(
      url: "wss://e4-push.kambi.com/socket.io/?EIO=3&transport=websocket",
      onConnected: (client) => client.subscribe("ub.ev"));
  push.connect();

  new Timer(new Duration(seconds: 10), () => push.close());
}
