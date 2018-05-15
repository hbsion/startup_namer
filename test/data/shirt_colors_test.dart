import 'dart:convert';

import 'package:svan_play/data/shirt_colors.dart';
import 'package:test/test.dart';


main() {
  test("should decode shirt colors", () {
    var text = '''{
              "shirtColor1": "#ffffff",
              "shirtColor2": "#eeeeee"
             }''';
    var c = ShirtColors.fromJson(json.decode(text));

    expect(c.shirtColor1, "#ffffff");
    expect(c.shirtColor2, "#eeeeee");
  });
}
