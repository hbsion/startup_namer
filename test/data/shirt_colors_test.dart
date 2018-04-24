import 'dart:convert';

import 'package:startup_namer/data/race_history_stat.dart';
import 'package:startup_namer/data/shirt_colors.dart';
import 'package:test/test.dart';


main() {
  test("should decode shirt colors", () {
    var text = '''{
              "shirtColor1": "#ffffff",
              "shirtColor2": "#eeeeee"
             }''';
    var c = ShirtColors.fromJson(json.decode(text));

    expect(c.shirtColor1, "#ffffff");
    expect(c.shirtColor1, "#eeeeee");
  });
}
