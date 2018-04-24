import 'dart:convert';

import 'package:startup_namer/data/each_way.dart';
import 'package:startup_namer/data/group_path.dart';
import 'package:test/test.dart';


main() {
  test("should decode grouppath json", () {
    var text = '''{
           "id": 2000065773,
           "name": "Galopp",
           "englishName": "Horse Racing",
           "termKey": "horse_racing"
         }''';
    var c = GroupPath.fromJson(json.decode(text));

    expect(c.id, 2000065773);
    expect(c.name, "Galopp");
    expect(c.termKey, "horse_racing");
  });
}
