import 'package:flutter/material.dart';
import 'package:startup_namer/pages/home_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final appTitle = 'Play!';

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: appTitle,
        theme: new ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.black
        ),
        home: new HomePage()
    );
  }
}
