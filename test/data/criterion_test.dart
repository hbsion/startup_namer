import 'package:svan_play/data/criterion.dart';
import 'package:test/test.dart';
import 'dart:convert';


main() {
  test("should map json to criterion object", () {
     var text = '''{
     "id": 1001159858,
     "label": "Full Time",
     "englishLabel": "Full Time",
     "order": [1,2,3]
     }''';
    var c = Criterion.fromJson(json.decode(text));

    expect(c.id, 1001159858);
    expect(c.label, "Full Time");
    expect(c.order, [1,2,3]);
  });

}
