import 'dart:convert';

import 'package:svan_play/data/score.dart';
import 'package:test/test.dart';


main() {
  test("should decode json", () {
     var text = '''{
       "home": "28",
       "away": "20",
       "info": "HT: 13-11",
       "who": "UNKNOWN"
     }''';
    var c = Score.fromJson(json.decode(text));

    expect(c.home, "28");
    expect(c.away, "20");
    expect(c.info, "HT: 13-11");
    expect(c.who, "UNKNOWN");
  });

}
