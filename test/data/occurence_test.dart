import 'dart:convert';

import 'package:svan_play/data/occurence.dart';
import 'package:test/test.dart';

void main() {
  test("Should decode json", () {
    var text = '''{
    "id": 277099480,
    "eventId": 1004706808,
    "occurrenceTypeId": "CORNERS_AWAY",
    "secondInPeriod": 79,
    "secondInMatch": 79,
    "periodId": "FIRST_HALF",
    "action": "ADDED",
    "periodIndex": 0
    }''';
    var c = Occurence.fromJson(json.decode(text));

    expect(c.id, 277099480);
    expect(c.eventId, 1004706808);
    expect(c.occurrenceTypeId, "CORNERS_AWAY");
    expect(c.secondInPeriod, 79);
    expect(c.secondInMatch, 79);
    expect(c.periodIndex, 0);
    expect(c.periodId, "FIRST_HALF");
    expect(c.action, "ADDED");
  });
}
