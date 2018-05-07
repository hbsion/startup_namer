import 'package:startup_namer/push/push_client.dart';

void main() {
  PushClient client = new PushClient('wss://e4-push.kambi.com/socket.io/?EIO=3&transport=websocket');
  client.messageStream.listen((pm) => print(pm.toString()));
  client.connectStream.listen((_) {
    print("on connect");
    client.subscribe("v2018.ub.ev");
  });

  client.connect();
}
