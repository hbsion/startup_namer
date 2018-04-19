import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class ListThemeData {
  final Color headerBackground;
  final Color headerDivider;
  final Color itemDivider;

  ListThemeData({
    @required this.headerBackground,
    @required this.headerDivider,
    @required this.itemDivider,
  });

}

class AppThemeData {
  final ListThemeData list;

  AppThemeData({@required this.list});
}

class AppTheme {
  static final AppThemeData _dark = new AppThemeData(
      list: ListThemeData(
          headerBackground: Colors.black87,
          headerDivider: Color.fromARGB(255, 0xa9, 0xa9, 0xa9),
          itemDivider: Color.fromARGB(255, 0xa9, 0xa9, 0xa9),
      )
  );
  static final AppThemeData _light = new AppThemeData(
      list: ListThemeData(
          headerBackground: Colors.white,
          headerDivider: Color.fromARGB(255, 0xd1, 0xd1, 0xd1),
          itemDivider: Color.fromARGB(255, 0xd1, 0xd1, 0xd1),
      )
  );

  static AppThemeData of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? _light : _dark;
  }
}