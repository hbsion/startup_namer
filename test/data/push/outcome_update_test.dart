import 'dart:convert';

import 'package:startup_namer/data/push/outcome_update.dart';
import 'package:test/test.dart';

void main() {
  var text = '''
   {
     "id": 2433947795,
     "odds": 1120,
     "betOfferId": 2121701843,
     "oddsFractional": "1/9",
     "oddsAmerican": "-835"
   }
  ''';
  test("should decode json", () {
    var c = OutcomeUpdate.fromJson(json.decode(text));

    expect(c.id, 2433947795);
    expect(c.odds.decimal, 1120);
    expect(c.odds.fractional, "1/9");
    expect(c.odds.american, "-835");
  });
}