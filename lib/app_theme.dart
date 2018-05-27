import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

const Color _brandColor = Color.fromRGBO(0x00, 0xad, 0xc9, 1.0);
const Color brandColorDark = Color.fromRGBO(0x00, 0x93, 0xb5, 1.0);

class ListThemeData {
  final Color headerBackground;
  final Color headerForeground;
  final Color headerDivider;
  final Color itemDividerColor;

  ListThemeData({
    @required this.headerBackground,
    @required this.headerForeground,
    @required this.headerDivider,
    @required this.itemDividerColor,
  });
}

class TabThemeData {
  final Color selectedColor;
  final Color defaultColor;

  TabThemeData({@required this.selectedColor, @required this.defaultColor});
}

class OutcomeThemeData {
  final Color _background = _brandColor;
  final Color _text = Colors.white;

  final Color _disabledBackground = Colors.grey;
  final Color _disabledText = Colors.white;

  final Color oddsUp = Colors.red;
  final Color oddsDown = Colors.lightGreenAccent;

  Color background({bool disabled = false}) => disabled ? _disabledBackground : _background;

  Color text({bool disabled = false}) => disabled ? _disabledText : _text;
}

class AppThemeData {
  final ListThemeData list;
  final OutcomeThemeData outcome;
  final TabThemeData tabs;
  final Color serverColor = Color.fromRGBO(0xf7, 0xce, 0x00, 1.0);
  final Color pointsColor = Color.fromRGBO(0x00, 0xad, 0xc9, 1.0);
  final Color brandColor = _brandColor;

  AppThemeData({@required this.list, @required this.outcome, @required this.tabs});
}

class AppTheme {
  static final AppThemeData _dark = new AppThemeData(
      list: ListThemeData(
        headerBackground: Colors.black87,
        headerForeground: Colors.white70,
        headerDivider: Color.fromARGB(255, 0xa9, 0xa9, 0xa9),
        itemDividerColor: Color.fromARGB(255, 0xa9, 0xa9, 0xa9),
      ),
      outcome: OutcomeThemeData(),
      tabs: TabThemeData(selectedColor: _brandColor, defaultColor: Colors.white));
  static final AppThemeData _light = new AppThemeData(
      list: ListThemeData(
        headerBackground: Colors.white,
        headerForeground: Colors.black87,
        headerDivider: Color.fromARGB(255, 0xd1, 0xd1, 0xd1),
        itemDividerColor: Color.fromARGB(255, 0xd1, 0xd1, 0xd1),
      ),
      outcome: OutcomeThemeData(),
      tabs: TabThemeData(selectedColor: _brandColor, defaultColor: Colors.black87));

  static AppThemeData of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? _light : _dark;
  }
}
