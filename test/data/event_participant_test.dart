import 'dart:convert';

import 'package:svan_play/data/event_participant.dart';
import 'package:test/test.dart';


main() {
  test("should decode event participant json", () {

    var text = ''' {
          "participantId": 1002892758,
          "name": "Mengli Khan",
          "extended": {
            "startNumber": 6,
            "driverName": "J W Kennedy",
            "age": "5",
            "weight": "11st 12lbs",
            "editorial": "",
            "hasIcon": true,
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
          },
          "scratched": false,
          "nonRunner": true,
          "startNumber": 6
        }''';
    var c = EventParticipant.fromJson(json.decode(text));

    expect(c.id, 1002892758);
    expect(c.name, "Mengli Khan");
    expect(c.startNumber, 6);
    expect(c.nonRunner, true);
    expect(c.scratched, false);
    expect(c.extended, isNotNull);
  });
}
