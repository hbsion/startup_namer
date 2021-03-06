import 'dart:convert';

import 'package:svan_play/data/live_stats.dart';
import 'package:test/test.dart';

main() {
  test("should decode json", () {
    var text = '''{
       "eventId": 1004058691,
       "matchClock": {
         "minute": 95,
         "second": 31,
         "period": "Andra halvlek",
         "running": true
       },
       "score": {
         "home": "1",
         "away": "1",
         "who": "HOME"
       },
       "statistics": {
         "football": {
           "home": {
             "yellowCards": 1,
             "redCards": 0,
             "corners": 3
           },
           "away": {
             "yellowCards": 4,
             "redCards": 1,
             "corners": 4
           }
         }
       },
       "occurrences": [
          {
            "id": 277099480,
            "eventId": 1004706808,
            "occurrenceTypeId": "CORNERS_AWAY",
            "secondInPeriod": 79,
            "secondInMatch": 79,
            "periodId": "FIRST_HALF",
            "action": "ADDED",
            "periodIndex": 0
          }
       ]
     }''';
    var c = LiveStats.fromJson(json.decode(text));

    expect(c.eventId, 1004058691);
    expect(c.score.away, "1");
    expect(c.eventStats.football.home.corners, 3);
    expect(c.occurences[0].id, 277099480);
  });
}
