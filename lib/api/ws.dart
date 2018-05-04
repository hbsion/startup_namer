import 'package:web_socket_channel/io.dart';

void main() {
  var sentSub = false;
  final channel = new IOWebSocketChannel.connect('wss://e2-push.aws.kambicdn.com/socket.io/?EIO=3&transport=websocket');
  channel.stream.listen(
          (data) {
            var text = data.toString();
            print("Data: " + text);
            if (text.startsWith("0{")) {
              print("Connect");
            } else if(text.startsWith("40")) {
              print("init");
              channel.sink.add('42["subscribe", {topic: "ub.ev.json"}]');
            }
          },
      onDone: () => print("Done"),
      onError: (error) => print("Error")
  );
}
