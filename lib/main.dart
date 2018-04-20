import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:startup_namer/models/main_model.dart';
import 'package:startup_namer/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(new MainApp());

class MainApp extends StatelessWidget {
  final appTitle = 'Play!';

  @override
  Widget build(BuildContext context) {
//    SharedPreferences prefs = SharedPreferences.getInstance();
    return new ScopedModel<MainModel>(
        model: new MainModel(),
        child: new ScopedModelDescendant<MainModel>(
            builder: (context, child, model) {
              return MaterialApp(
                  title: appTitle,
                  theme: new ThemeData(
                      brightness: model.brightness,
                      primaryColor: Colors.black,
                      accentColor: Color.fromARGB(0xff, 0x00, 0xad, 0xc9)
                  ),
                  home: HomePage()
              );
            }
        )
    );
  }
}
