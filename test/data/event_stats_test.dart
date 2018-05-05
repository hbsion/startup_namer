import 'package:startup_namer/data/each_way.dart';
import 'package:startup_namer/data/event_stats.dart';
import 'package:startup_namer/data/football_stats.dart';
import 'package:startup_namer/data/score.dart';
import 'package:test/test.dart';
import 'dart:convert';


main() {
  test("should decode json", () {
     var text = '''{
       "sets": {
         "home": [
           22,
           25,
           25,
           -1,
           -1
         ],
         "away": [
           25,
           13,
           17,
           -1,
           -1
         ],
         "homeServe": true
       },
       "football": {
         "home": {
           "yellowCards": 0,
           "redCards": 0,
           "corners": 0
         },
         "away": {
           "yellowCards": 0,
           "redCards": 0,
           "corners": 2
         }
       }
     }''';
    var c = EventStats.fromJson(json.decode(text));

    expect(c.sets.home,  [22,25,25,-1,-1]);
    expect(c.football.away.corners, 2);
  });

}
