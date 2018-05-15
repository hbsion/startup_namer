import 'dart:convert';

import 'package:svan_play/data/cashout_status.dart';
import 'package:svan_play/data/outcome.dart';
import 'package:svan_play/data/outcome_status.dart';
import 'package:svan_play/data/outcome_type.dart';
import 'package:test/test.dart';


main() {
  test("should decode outcome json", () {
    var text = '''{
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
                "line": 2,
                "startNr": 4,
                "popular": true,
                "scratched": false,
                "distance": "152m",
                "cashOutStatus": "ENABLED",
                "criterion": {
                     "type": "ty",
                     "name": "Full Time"
                 }
            }''';
    var c = Outcome.fromJson(json.decode(text));

    expect(c.id, 2422774002);
    expect(c.label, "1");
    expect(c.odds.decimal, 1800);
    expect(c.odds.american, "-125");
    expect(c.odds.fractional, "4/5");
    expect(c.participant, "Newcastle United");
    expect(c.type, OutcomeType.ONE);
    expect(c.betOfferId, 2118600641);
    expect(c.changedDate, DateTime.utc(2018, 4, 22, 17, 23, 29));
    expect(c.participantId, 1000000044);
    expect(c.status, OutcomeStatus.OPEN);
    expect(c.cashoutStatus, CashoutStatus.ENABLED);
    expect(c.distance, "152m");
    expect(c.popular, true);
    expect(c.scratched, false);
    expect(c.line, 2);
    expect(c.criterion, isNotNull);
  });
}
