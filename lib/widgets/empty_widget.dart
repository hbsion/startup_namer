import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(width: 0.0, height: 0.0);
  }
}

Widget emptyIfNull({@required value, @required Widget widget}){
  if (value == null) {
    return new EmptyWidget();
  }
  return widget;
}