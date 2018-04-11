import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  final String title;

  StartPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: Image.asset("assets/banner_1.jpg")
    );
  }
}
