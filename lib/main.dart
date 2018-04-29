import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:startup_namer/api/offering_api.dart';
import 'package:startup_namer/models/main_model.dart';
import 'package:startup_namer/pages/home_page.dart';
import 'package:startup_namer/store/action_type.dart';
import 'package:startup_namer/store/app_store.dart';
import 'package:startup_namer/store/store_dispatcher.dart';
import 'package:startup_namer/store/store_provider.dart';

void main() {
  Logger.root.level = Level.ALL;

  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  runApp(new MainApp());
}

class MainApp extends StatelessWidget {
  final appTitle = 'Play!';

  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
        store: new AppStore(),
        child: new StoreDispatcher(
            action: _defaultActions,
            child: new ScopedModel<MainModel>(
                model: new MainModel(),
                child: _buildMainApp()
            )
        ));
  }

  ScopedModelDescendant<MainModel> _buildMainApp() {
    return new ScopedModelDescendant<MainModel>(
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
    );
  }

  Future _defaultActions(Dispatcher dispatcher) async {
    // actions that run in background not tied to any particular view
    var reponse = await fetchLiveOpen();
    dispatcher(ActionType.eventResponse, reponse);
  }
}
