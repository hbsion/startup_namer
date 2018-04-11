import 'package:flutter/material.dart';
import 'package:startup_namer/drawer_app.dart';
import 'package:startup_namer/random_words.dart';

void main() => runApp(new DrawerApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Startup Name Generator',
      home: new RandomWords(),
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
    );
  }
}
