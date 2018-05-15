import 'dart:convert';

import 'package:svan_play/data/push/push_message.dart';
import 'package:svan_play/data/push/push_message_type.dart';
import 'package:test/test.dart';

void main() {
  test("should decode odds update", () {
    var text = '''
     {
       "t": "1525452459888",
       "mt": 11,
       "boou": {
         "eventId": 1004656243,
         "outcomes": [
           {
             "id": 2433947795,
             "odds": 1120,
             "betOfferId": 2121701843,
             "oddsFractional": "1/9",
             "oddsAmerican": "-835"
           }
         ]
       }
     }
     ''';
    var c = PushMessage.fromJson(json.decode(text));

    expect(c.type, PushMessageType.oddsUpdate);
    expect(c.oddsUpdate.eventId, 1004656243);
  });
}
