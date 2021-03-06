import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logging/logging.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:svan_play/api/api_constants.dart';
import 'package:svan_play/models/main_model.dart';
import 'package:svan_play/pages/home_page.dart';
import 'package:svan_play/push/push_client.dart';
import 'package:svan_play/push/push_hub.dart';
import 'package:svan_play/push/push_provider.dart';
import 'package:svan_play/samples/svg_demo.dart';
import 'package:svan_play/store/actions.dart';
import 'package:svan_play/store/app_store.dart';
import 'package:svan_play/store/store_dispatcher.dart';
import 'package:svan_play/store/store_provider.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  AppStore store = new AppStore();
  PushClient pushClient = new PushClient('wss://e4-push.kambi.com/socket.io/?EIO=3&transport=websocket');
  PushHub pushHub = new PushHub(pushClient, store.dispatch);
  pushHub.connect(["ev", "${ApiConstants.pushLang}.ev"]);

  runApp(new MainApp(store: store, pushHub: pushHub));
}

class MainApp extends StatelessWidget {
  final appTitle = 'Play!';
  final AppStore store;
  final PushHub pushHub;

  const MainApp({Key key, this.store, this.pushHub}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new PushProvider(
      pushHub: pushHub,
      child: new StoreProvider(
        store: store,
        child: new StoreDispatcher(
          pollAction: _pollActions,
          initAction: _initActions,
          child: new ScopedModel<MainModel>(
            model: new MainModel(),
            child: _buildMainApp(),
          ),
        ),
      ),
    );
  }

  ScopedModelDescendant<MainModel> _buildMainApp() {
    return new ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return MaterialApp(
//              showPerformanceOverlay: true,
//              checkerboardOffscreenLayers: true,
//              checkerboardRasterCacheImages: true,
        title: appTitle,
        theme: new ThemeData(
          brightness: model.brightness,
          primaryColor: Colors.black,
          accentColor: Color.fromARGB(0xff, 0x00, 0xad, 0xc9),
        ),
        home: new HomePage(),
      );
    });
  }

  Future _pollActions(Dispatcher dispatcher) async {
    liveOpen()(dispatcher);
  }

  Future _initActions(Dispatcher dispatcher) async {
    eventGroups()(dispatcher);
    highlights()(dispatcher);
  }
}
