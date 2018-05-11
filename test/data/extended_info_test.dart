import 'dart:convert';

import 'package:startup_namer/data/extended_info.dart';
import 'package:test/test.dart';


main() {
  test("should decode extended info json", () {
    var text = '''{
            "startNumber": 6,
            "driverName": "J W Kennedy",
            "age": "5",
            "weight": "11st 12lbs",
            "editorial": "hej hopp",
            "hasIcon": true,
            "icon": "xyz",
            "trainerName": "G Elliott",
            "formFigures": [
              {
                "type": "JumpSix",
                "figures": "111R23"
              }
            ],
            "lastRunDays": [
              {
                "type": "Flat",
                "days": "562"
              },
              {
                "type": "Jump",
                "days": "42"
              }
            ],
            "raceHistoryStat": [
              {
                "type": "Distance",
                "stat": "3"
              }
            ]
          }''';
    var c = ExtendedInfo.fromJson(json.decode(text));

    expect(c.startNumber, 6);
    expect(c.driverName, "J W Kennedy");
    expect(c.age, "5");
    expect(c.weight, "11st 12lbs");
    expect(c.editorial, "hej hopp");
    expect(c.hasIcon, true);
    expect(c.icon, "xyz");
    expect(c.trainerName, "G Elliott");
    expect(c.formFigures.length, equals(1));
    expect(c.lastRunDays.length, equals(2));
    expect(c.raceHistoryStat.length, equals(1));

  });
}
