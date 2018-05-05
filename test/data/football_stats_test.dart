import 'package:startup_namer/data/each_way.dart';
import 'package:startup_namer/data/football_stats.dart';
import 'package:startup_namer/data/score.dart';
import 'package:test/test.dart';
import 'dart:convert';


main() {
  test("should decode json", () {
     var text = '''{
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
     }''';
    var c = FootballStats.fromJson(json.decode(text));

    expect(c.home.yellowCards, 1);
    expect(c.away.yellowCards, 4);
  });

}
