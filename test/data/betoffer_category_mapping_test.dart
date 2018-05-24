import 'dart:convert';

import 'package:svan_play/data/betoffer_category_mapping.dart';
import 'package:test/test.dart';

var text = '''{
"criterionId": 1002940287,
"boType": 2,
"sortOrder": 5
}''';

main() {
  test("should parse json", () {
    var c = BetOfferCategoryMapping.fromJson(json.decode(text));
    expect(c.criterionId, 1002940287);
    expect(c.boType, 2);
    expect(c.sortOrder, 5);
  });

  test("Should be equal", () {
    var one = BetOfferCategoryMapping.fromJson(json.decode(text));
    var two = BetOfferCategoryMapping.fromJson(json.decode(text));

    expect(one == two, true);
  });
}
