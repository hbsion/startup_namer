import 'dart:convert';

import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/data/event_state.dart';
import 'package:test/test.dart';

main() {
  var text = '''{
      "id": 1004642213,
      "name": "Punchestown",
      "englishName": "Punchestown",
      "homeName": "Punchestown-Home",
      "start": "2018-04-24T15:21:00Z",
      "originalStartTime": "16:20",
      "group": "Punchestown group",
      "groupId": 2000115132,
      "path": [
        {
          "id": 2000065773,
          "name": "Galopp",
          "englishName": "Horse Racing",
          "termKey": "horse_racing"
        },
        {
          "id": 2000068281,
          "name": "UK & Ireland",
          "englishName": "UK & Ireland",
          "termKey": "uk___ireland"
        },
        {
          "id": 2000115132,
          "name": "Punchestown",
          "englishName": "Punchestown",
          "termKey": "punchestown"
        }
      ],
      "nonLiveBoCount": 0,
      "sport": "GALLOPS",
      "tags": [
        "STREAMED_WEB",
        "COMPETITION",
        "SHOW_START_NUMBER",
        "STREAMED_MOBILE"
      ],
      "state": "STARTED",
      "distance": "2m 100y",
      "eventNumber": 1,
      "editorial": "yo",
      "raceClass": "1",
      "raceType": "Hurdle",
      "trackType": "Turf",
      "going": "Yielding to Soft",
      "participants": [
        {
          "participantId": 1003152432,
          "name": "Beyond The Law",
          "extended": {
            "startNumber": 1,
            "driverName": "B J Cooper",
            "age": "6",
            "weight": "11st 12lbs",
            "editorial": "",
            "hasIcon": true,
            "trainerName": "M F Morris",
            "formFigures": [
              {
                "type": "JumpSix",
                "figures": "43114P"
              }
            ],
            "lastRunDays": [
              {
                "type": "Jump",
                "days": "39"
              }
            ]
          },
          "scratched": false,
          "nonRunner": false,
          "startNumber": 1
        },
        {
          "participantId": 1003700818,
          "name": "Getabird",
          "extended": {
            "startNumber": 4,
            "driverName": "P Townend",
            "age": "6",
            "weight": "11st 12lbs",
            "editorial": "",
            "hasIcon": true,
            "trainerName": "W P Mullins",
            "formFigures": [
              {
                "type": "JumpSix",
                "figures": "11-1101"
              }
            ],
            "lastRunDays": [
              {
                "type": "Jump",
                "days": "22"
              }
            ],
            "raceHistoryStat": [
              {
                "type": "Course",
                "stat": "1"
              },
              {
                "type": "CourseDistance",
                "stat": "1"
              },
              {
                "type": "Distance",
                "stat": "3"
              }
            ]
          },
          "scratched": false,
          "nonRunner": false,
          "startNumber": 4
        },
        {
          "participantId": 1003212592,
          "name": "Hardline",
          "extended": {
            "startNumber": 5,
            "driverName": "S W Flanagan",
            "age": "6",
            "weight": "11st 12lbs",
            "editorial": "",
            "hasIcon": true,
            "trainerName": "G Elliott",
            "formFigures": [
              {
                "type": "JumpSix",
                "figures": "133113"
              }
            ],
            "lastRunDays": [
              {
                "type": "Jump",
                "days": "22"
              }
            ],
            "raceHistoryStat": [
              {
                "type": "CourseDistance",
                "stat": "2"
              },
              {
                "type": "Distance",
                "stat": "4"
              }
            ]
          },
          "scratched": false,
          "nonRunner": false,
          "startNumber": 5
        },
        {
          "participantId": 1002963933,
          "name": "Cartwright",
          "extended": {
            "startNumber": 2,
            "driverName": "M P Walsh",
            "age": "5",
            "weight": "11st 12lbs",
            "editorial": "",
            "hasIcon": true,
            "trainerName": "G Elliott",
            "formFigures": [
              {
                "type": "JumpSix",
                "figures": "2141"
              }
            ],
            "lastRunDays": [
              {
                "type": "Flat",
                "days": "231"
              },
              {
                "type": "Jump",
                "days": "32"
              }
            ],
            "raceHistoryStat": [
              {
                "type": "Distance",
                "stat": "4"
              }
            ]
          },
          "scratched": false,
          "nonRunner": false,
          "startNumber": 2
        },
        {
          "participantId": 1004386794,
          "name": "Draconien",
          "extended": {
            "startNumber": 3,
            "driverName": "N D Fehily",
            "age": "5",
            "weight": "11st 12lbs",
            "editorial": "",
            "hasIcon": true,
            "trainerName": "W P Mullins",
            "formFigures": [
              {
                "type": "JumpSix",
                "figures": "4-12U2"
              }
            ],
            "lastRunDays": [
              {
                "type": "Jump",
                "days": "22"
              }
            ]
          },
          "scratched": false,
          "nonRunner": false,
          "startNumber": 3
        },
        {
          "participantId": 1003210800,
          "name": "Sharjah",
          "extended": {
            "startNumber": 8,
            "driverName": "Mr P W Mullins",
            "age": "5",
            "weight": "11st 12lbs",
            "editorial": "",
            "hasIcon": true,
            "trainerName": "W P Mullins",
            "formFigures": [
              {
                "type": "JumpSix",
                "figures": "11F784"
              }
            ],
            "lastRunDays": [
              {
                "type": "Flat",
                "days": "579"
              },
              {
                "type": "Jump",
                "days": "22"
              }
            ],
            "raceHistoryStat": [
              {
                "type": "Distance",
                "stat": "2"
              }
            ]
          },
          "scratched": false,
          "nonRunner": false,
          "startNumber": 8
        },
        {
          "participantId": 1003942756,
          "name": "Vision Des Flos",
          "extended": {
            "startNumber": 9,
            "driverName": "R M Power",
            "age": "5",
            "weight": "11st 12lbs",
            "editorial": "",
            "hasIcon": true,
            "trainerName": "C L Tizzard",
            "formFigures": [
              {
                "type": "JumpSix",
                "figures": "342162"
              }
            ],
            "lastRunDays": [
              {
                "type": "Jump",
                "days": "11"
              }
            ],
            "raceHistoryStat": [
              {
                "type": "CourseDistance",
                "stat": "1"
              }
            ]
          },
          "scratched": false,
          "nonRunner": false,
          "startNumber": 9
        },
        {
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
          "nonRunner": false,
          "startNumber": 6
        },
        {
          "participantId": 1003733057,
          "name": "Paloma Blue",
          "extended": {
            "startNumber": 7,
            "driverName": "D N Russell",
            "age": "6",
            "weight": "11st 12lbs",
            "editorial": "",
            "hasIcon": true,
            "trainerName": "H de Bromhead",
            "formFigures": [
              {
                "type": "JumpSix",
                "figures": "2-32134"
              }
            ],
            "lastRunDays": [
              {
                "type": "Jump",
                "days": "42"
              }
            ],
            "raceHistoryStat": [
              {
                "type": "Distance",
                "stat": "2"
              }
            ]
          },
          "scratched": false,
          "nonRunner": false,
          "startNumber": 7
        },
        {
          "participantId": 1002734021,
          "name": "Whiskey Sour",
          "extended": {
            "startNumber": 10,
            "driverName": "D J Mullins",
            "age": "5",
            "weight": "11st 12lbs",
            "editorial": "",
            "hasIcon": true,
            "trainerName": "W P Mullins",
            "formFigures": [
              {
                "type": "JumpSix",
                "figures": "1143"
              }
            ],
            "lastRunDays": [
              {
                "type": "Flat",
                "days": "263"
              },
              {
                "type": "Jump",
                "days": "39"
              }
            ],
            "raceHistoryStat": [
              {
                "type": "Distance",
                "stat": "2"
              }
            ]
          },
          "scratched": false,
          "nonRunner": false,
          "startNumber": 10
        }
      ],
      "groupSortOrder": 3875819019684212700,
      "prematchEnd": "2018-04-24T15:22:00Z",
      "meetingId": "38197",
      "teamColors": {
        "home": {
          "shirtColor1": "#ffffff",
          "shirtColor2": "#ffffff"
         },
        "away": {
         "shirtColor1": "#000000",
         "shirtColor2": "#000000"
      }
      }
    }''';


  test("should decode event json", () {
    var c = Event.fromJson(json.decode(text));

    expect(c.id, 1004642213);
    expect(c.name, "Punchestown");
    expect(c.homeName, "Punchestown-Home");
    expect(c.start, DateTime.utc(2018, 4, 24, 15, 21, 00));
    expect(c.originalStartTime, "16:20");
    expect(c.group, "Punchestown group");
    expect(c.path.length, 3);
    expect(c.groupId, 2000115132);
    expect(c.nonLiveBoCount, 0);
    expect(c.sport, "GALLOPS");
    expect(c.tags, ["STREAMED_WEB", "COMPETITION", "SHOW_START_NUMBER", "STREAMED_MOBILE"]);
    expect(c.state, EventState.STARTED);
    expect(c.distance, "2m 100y");
    expect(c.eventNumber, 1);
    expect(c.editorial, "yo");
    expect(c.raceClass, "1");
    expect(c.trackType, "Turf");
    expect(c.going, "Yielding to Soft");
    expect(c.participants.length, 10);
    expect(c.groupSortOrder, 3875819019684212700);
    expect(c.prematchEnd, DateTime.utc(2018, 4, 24, 15, 22, 00));
    expect(c.meetingId, "38197");
    expect(c.teamColors, isNotNull);
  });
}