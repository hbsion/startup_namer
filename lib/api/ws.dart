import 'package:startup_namer/api/push_client.dart';

void main() {
  PushClient client = new PushClient('wss://e4-push.kambi.com/socket.io/?EIO=3&transport=websocket');
  client.observable.listen((pm) => print(pm.toString()));
  
  client.connect();
}
