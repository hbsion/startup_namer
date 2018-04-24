import 'package:startup_namer/data/criterion.dart';
import 'package:startup_namer/data/outcome_criterion.dart';
import 'package:test/test.dart';
import 'dart:convert';


main() {
  test("should decode outcome criterion json", () {
     var text = '''{
     "type": "ty",
     "name": "Full Time"
     }''';
    var c = OutcomeCriterion.fromJson(json.decode(text));

    expect(c.type, "ty");
    expect(c.name, "Full Time");
  });

}
