import 'dart:convert';

import 'package:svan_play/data/team_stats.dart';
import 'package:test/test.dart';


main() {
  test("should decode json", () {
     var text = '''{
       "yellowCards": 1,
       "redCards": 0,
       "corners": 3
     }''';
    var c = TeamStats.fromJson(json.decode(text));

    expect(c.yellowCards, 1);
    expect(c.redCards, 0);
    expect(c.corners, 3);
  });

}
