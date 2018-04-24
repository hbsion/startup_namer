import 'dart:convert';

import 'package:startup_namer/data/race_history_stat.dart';
import 'package:test/test.dart';


main() {
  test("should decode race history stat", () {
    var text = ''' {
                "type": "Distance",
                "stat": "3"
              }''';
    var c = RaceHistoryStat.fromJson(json.decode(text));

    expect(c.type, "Distance");
    expect(c.stat, "3");
  });
}
