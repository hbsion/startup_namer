import 'dart:convert';

import 'package:startup_namer/data/race_history_stat.dart';
import 'package:startup_namer/data/shirt_colors.dart';
import 'package:startup_namer/data/team_colors.dart';
import 'package:test/test.dart';


main() {
  test("should decode team colors", () {
    var text = '''{
            "home": {
              "shirtColor1": "#ffffff",
              "shirtColor2": "#ffffff"
             },
            "away": {
             "shirtColor1": "#000000",
             "shirtColor2": "#000000"
          }
          }''';
    var c = TeamColors.fromJson(json.decode(text));

    expect(c.home.shirtColor1, "#ffffff");
    expect(c.away.shirtColor2, "#000000");
  });
}
