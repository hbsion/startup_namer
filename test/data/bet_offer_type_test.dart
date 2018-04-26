import 'dart:convert';

import 'package:startup_namer/data/betoffer_type.dart';
import 'package:test/test.dart';

var text = '''{
   "id": 2,
   "name": "Match",
   "englishName": "Match"
   }''';

main() {
  test("should parse json", () {
    var c = BetOfferType.fromJson(json.decode(text));
    expect(c.id, 2);
    expect(c.name, "Match");
  });

  test("Should be equal", () {
    var one = BetOfferType.fromJson(json.decode(text));
    var two = BetOfferType.fromJson(json.decode(text));

    expect(one == two, true);
  });
}