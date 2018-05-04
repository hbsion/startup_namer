import 'package:startup_namer/api/push_client.dart';


void main() {
  var push = new PushClient("wss://e4-push.kambi.com/socket.io/?EIO=3&transport=websocket");
  push.connect();
}