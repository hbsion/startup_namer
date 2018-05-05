import 'package:startup_namer/data/each_way.dart';
import 'package:startup_namer/data/football_stats.dart';
import 'package:startup_namer/data/score.dart';
import 'package:startup_namer/data/set_stats.dart';
import 'package:test/test.dart';
import 'dart:convert';


main() {
  test("should decode json", () {
     var text = '''{
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
     }''';
    var c = SetStats.fromJson(json.decode(text));

    expect(c.home, [22,25,25,-1,-1]);
    expect(c.away, [25,13,17,-1,-1]);
    expect(c.homeServe, true);
  });

}
