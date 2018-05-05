import 'package:startup_namer/data/each_way.dart';
import 'package:startup_namer/data/event_stats.dart';
import 'package:startup_namer/data/football_stats.dart';
import 'package:startup_namer/data/live_stats.dart';
import 'package:startup_namer/data/score.dart';
import 'package:test/test.dart';
import 'dart:convert';


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
       }
     }''';
    var c = LiveStats.fromJson(json.decode(text));

    expect(c.eventId, 1004058691);
    expect(c.score.away, "1");
    expect(c.statistics.football.home.corners, 3);
  });

}
