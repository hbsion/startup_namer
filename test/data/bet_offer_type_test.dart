import 'dart:convert';

import 'package:startup_namer/data/betoffer_type.dart';
import 'package:test/test.dart';

main() {
  test("should parse json", () {
    var text = '''{
    "id": 2,
    "name": "Match",
    "englishName": "Match"
    }''';
    var c = BetOfferType.fromJson(json.decode(text));

    expect(c.id, 2);
    expect(c.name, "Match");
  });
}