import 'dart:convert';

import 'package:svan_play/data/betoffer.dart';
import 'package:svan_play/data/cashout_status.dart';
import 'package:test/test.dart';

var text = '''{
     "id": 2118600641,
     "criterion": {
        "closed": "2018-04-28T14:00:00Z",
        "id": 1001159858,
        "label": "Full Time",
        "englishLabel": "Full Time",
        "order": []
     },
     "betOfferType": {
       "id": 2,
       "name": "Match",
       "englishName": "Match"
     },
     "eventId": 1004058688,
     "outcomes": [
      {
          "id": 2422774002,
          "label": "1",
          "englishLabel": "1",
          "odds": 1800,
          "participant": "Newcastle United",
          "type": "OT_ONE",
          "betOfferId": 2118600641,
          "changedDate": "2018-04-22T17:23:29Z",
          "participantId": 1000000044,
          "oddsFractional": "4/5",
          "oddsAmerican": "-125",
          "status": "OPEN",
          "cashOutStatus": "ENABLED"
      },
      {
         "id": 2422774004,
         "label": "X",
         "englishLabel": "X",
         "odds": 3600,
         "type": "OT_CROSS",
         "betOfferId": 2118600641,
         "changedDate": "2018-04-22T17:23:29Z",
         "oddsFractional": "13/5",
         "oddsAmerican": "260",
         "status": "OPEN",
         "cashOutStatus": "ENABLED"
      },
      {
         "id": 2422774006,
         "label": "2",
         "englishLabel": "2",
         "odds": 4650,
         "participant": "West Bromwich",
         "type": "OT_TWO",
         "betOfferId": 2118600641,
         "changedDate": "2018-04-22T17:23:29Z",
         "participantId": 1000000072,
         "oddsFractional": "18/5",
         "oddsAmerican": "365",
         "status": "OPEN",
         "cashOutStatus": "ENABLED"
      }
   ],
   "tags": [
   "OFFERED_PREMATCH",
   "MAIN"
   ],
   "sortOrder": 1,
   "cashOutStatus": "ENABLED"
   }''';

main() {
  test("should decode betoffer json", () {

    var c = BetOffer.fromJson(json.decode(text));

    expect(c.id, 2118600641);
    expect(c.criterion.id, 1001159858);
    expect(c.betOfferType.id, 2);
    expect(c.eventId, 1004058688);
    expect(c.outcomes, [2422774002,2422774004,2422774006]);
    expect(c.tags, ["OFFERED_PREMATCH", "MAIN"]);
    expect(c.sortOrder, 1);
    expect(c.cashOutStatus, CashoutStatus.ENABLED);
  });


  test("should be equal", () {
    var one = BetOffer.fromJson(json.decode(text));
    var two = BetOffer.fromJson(json.decode(text));

    expect(one == two, isTrue);
  });
}