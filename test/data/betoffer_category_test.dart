import 'dart:convert';

import 'package:svan_play/data/betoffer_category.dart';
import 'package:svan_play/data/betoffer_category_mapping.dart';
import 'package:svan_play/data/betoffer_type.dart';
import 'package:test/test.dart';

var text = '''{
  "id": 11279,
  "name": "4",
  "sortOrder": 4,
  "displayBoTypeHeaders": true,
  "mappings": [
    {
      "criterionId": 1002940287,
      "boType": 2,
      "sortOrder": 5
    },
    {
      "criterionId": 1002955490,
      "boType": 2,
      "sortOrder": 10
    },
    {
      "criterionId": 1003042070,
      "boType": 2,
      "sortOrder": 15
    },
    {
      "criterionId": 1003042071,
      "boType": 2,
      "sortOrder": 20
    },
    {
      "criterionId": 1003042072,
      "boType": 2,
      "sortOrder": 25
    },
    {
      "criterionId": 1003042073,
      "boType": 2,
      "sortOrder": 30
    }
  ],
  "boCount": 0,
  "sport": "FOOTBALL"
}''';

main() {
  test("should parse json", () {
    var c = BetOfferCategory.fromJson(json.decode(text));
    expect(c.id, 11279);
    expect(c.name, "4");
    expect(c.displayBoTypeHeaders, true);
    expect(c.boCount, 0);
    expect(c.sport, "FOOTBALL");
    expect(c.mappings.length, 6);

  });

  test("Should be equal", () {
    var one = BetOfferCategory.fromJson(json.decode(text));
    var two = BetOfferCategory.fromJson(json.decode(text));

    expect(one == two, true);
  });
}
