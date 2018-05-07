import 'dart:convert';

import 'package:startup_namer/data/match_clock.dart';
import 'package:test/test.dart';

void main() {
  test("Should decode json", () {
    var text = '''{
      "minute": 57,
      "second": 29,
      "period": "Andra halvlek",
      "running": true
    }''';
    var c = MatchClock.fromJson(json.decode(text));

    expect(c.minute, 57);
    expect(c.second, 29);
    expect(c.period, "Andra halvlek");
    expect(c.running, true);
  });
}