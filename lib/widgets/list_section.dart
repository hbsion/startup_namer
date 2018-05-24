import 'package:flutter/material.dart';

abstract class ListSection {
  Widget leading;
  Widget trailing;
  TextStyle titleStyle;

  String get title;

  IndexedWidgetBuilder get builder;

  int get count;

  bool get initiallyExpanded;
}