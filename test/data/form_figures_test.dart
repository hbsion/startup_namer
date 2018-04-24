import 'dart:convert';

import 'package:startup_namer/data/form_figures.dart';
import 'package:test/test.dart';


main() {
  test("should formfigures json", () {
    var text = '''{
                "type": "JumpSix",
                "figures": "111R23"
              }''';
    var c = FormFigures.fromJson(json.decode(text));

    expect(c.type, "JumpSix");
    expect(c.figures, "111R23");
  });
}
