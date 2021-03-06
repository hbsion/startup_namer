import 'dart:convert';

import 'package:svan_play/data/push/odds_update.dart';
import 'package:test/test.dart';

void main() {
  var text = '''
   {
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
  ''';
  test("should decode json", () {
    var c = OddsUpdate.fromJson(json.decode(text));

    expect(c.eventId, 1004656243);
    expect(c.outcomes.length, 1);
  });
}