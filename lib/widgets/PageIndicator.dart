import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class PageIndicator extends AnimatedWidget {
  final List<String> titles;
  final PageController controller;
  final ValueChanged<int> onPageSelected;

  PageIndicator({@required this.titles, @required this.controller, @required this.onPageSelected})
      : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      hasNotch: true,
      child: new Container(
          height: 44.0,
          margin: EdgeInsets.only(right: 40.0),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _buildTabs(context).toList())),
    );
  }

  Iterable<Widget> _buildTabs(BuildContext context) sync* {
    for (var i = 0; i < titles.length; ++i) {
      var title = titles[i];
      yield _buildTab(context, title, i);
    }
  }

  Widget _buildTab(BuildContext context, String title, int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );

    var colorTween = ColorTween(begin: Colors.white, end: Theme.of(context).accentColor);
    var style = TextStyle(fontSize: 12.0 + 6 * selectedness, color: colorTween.lerp(selectedness));

    return Expanded(
        child: FlatButton(
      child: Text(title, style: style),
      onPressed: () => onPageSelected(index),
    ));
  }
}
