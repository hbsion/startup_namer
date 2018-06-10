import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var images = [
      "corner",
      "goal",
      "red-card",
      "yellow-card",
      "whistle",
    ];
    return new Scaffold(
      appBar: new AppBar(title: new Text("SVG demo")),
      body: new Column(
        children: images
            .map((img) => new Container(
                  width: 40.0,
                  height: 40.0,
                  child: new SvgPicture.asset(
                    "assets/svg/$img.svg",
                  ),
                ))
            .toList(),
      ),
    );
  }
}
