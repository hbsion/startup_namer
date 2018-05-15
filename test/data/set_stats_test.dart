import 'dart:convert';

import 'package:svan_play/data/set_stats.dart';
import 'package:test/test.dart';


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
