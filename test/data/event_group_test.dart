import 'dart:convert';

import 'package:svan_play/data/event_group.dart';
import 'package:test/test.dart';

main() {
  var text = ''' {
       "id": 1000093191,
       "name": "Ice Hockey",
       "boCount": 1442,
       "englishName": "Ice Hockey",
       "groups": [
         {
           "id": 1000093961,
           "name": "World Championship",
           "boCount": 738,
           "englishName": "World Championship",
           "sport": "ICE_HOCKEY",
           "eventCount": 69,
           "termKey": "world_championship",
           "sortOrder": "1"
         },
         {
           "id": 1000461910,
           "name": "Sweden",
           "boCount": 1,
           "englishName": "Sweden",
           "groups": [
             {
               "id": 1000094968,
               "name": "SHL",
               "boCount": 1,
               "englishName": "SHL",
               "sport": "ICE_HOCKEY",
               "eventCount": 1,
               "termKey": "shl",
               "sortOrder": "1"
             }
           ],
           "sport": "ICE_HOCKEY",
           "eventCount": 1,
           "termKey": "sweden",
           "sortOrder": "3"
         }
       ],
       "sport": "ICE_HOCKEY",
       "eventCount": 149,
       "termKey": "ice_hockey",
       "sortOrder": "4"
     }''';

  test("should decode event participant json", () {
    var c = EventGroup.fromJson(json.decode(text));

    expect(c.id, 1000093191);
    expect(c.name, "Ice Hockey");
    expect(c.termKey, "ice_hockey");
    expect(c.boCount, 1442);
    expect(c.eventCount, 149);
    expect(c.sortOrder, 4);
    expect(c.groups[0].id, 1000093961);
    expect(c.groups[0].parent.id, 1000093191);
    expect(c.groups[1].id, 1000461910);
    expect(c.groups[1].parent.id, 1000093191);
    expect(c.groups[1].groups[0].id, 1000094968);
    expect(c.groups[1].groups[0].parent.id, 1000461910);
  });

  test("should be equal", () {
     var eg1 = EventGroup.fromJson(json.decode(text));
     var eg2 = EventGroup.fromJson(json.decode(text));

     expect(eg1, eg2);
  });
}
