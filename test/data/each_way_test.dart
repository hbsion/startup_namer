import 'package:startup_namer/data/each_way.dart';
import 'package:test/test.dart';
import 'dart:convert';


main() {
  test("should decode each way json", () {
     var text = '''{
     "terms": "abc",
     "fractionMilli": 12345,
     "placeLimit": 23,
     "tags": ["a", "b"]
     }''';
    var c = EachWay.fromJson(json.decode(text));

    expect(c.terms, "abc");
    expect(c.fractionMilli, 12345);
    expect(c.placeLimit, 23);
    expect(c.tags, ["a", "b"]);
  });

}
