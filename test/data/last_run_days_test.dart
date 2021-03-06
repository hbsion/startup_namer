import 'dart:convert';

import 'package:svan_play/data/last_run_days.dart';
import 'package:test/test.dart';


main() {
  test("should decode lastrundays json", () {
    var text = '''{
                "type": "Flat",
                "days": "562"
              }''';
    var c = LastRunDays.fromJson(json.decode(text));

    expect(c.type, "Flat");
    expect(c.days, "562");
  });
}
