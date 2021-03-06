import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(width: 0.0, height: 0.0);
  }
}

Widget emptyIfTrue({@required bool condition, @required WidgetBuilder builder, @required BuildContext context}) {
  if (condition) {
    return new EmptyWidget();
  }
  return builder(context);
}
