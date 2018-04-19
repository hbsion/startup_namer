import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:startup_namer/main.dart';
import 'package:startup_namer/models/main_model.dart';


class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<MainModel>(
      builder: (context, child, model) =>
      new Column(
        children: <Widget>[
          new Text("Theme: " + model.brightness.toString()),
          new RaisedButton(
            onPressed: () =>
                model.updateTheme(model.brightness == Brightness.dark ? Brightness.light : Brightness.dark),
            child: Text("Change theme"),
          )
        ],
      ),
    );
  }

}