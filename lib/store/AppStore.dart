import 'package:meta/meta.dart';
import 'package:startup_namer/store/EventStore.dart';
import 'package:startup_namer/store/Store.dart';
import 'package:startup_namer/store/action_type.dart';

typedef Dispatcher = void Function(ActionType type, dynamic action);

class AppStore {
  final List<Store> _stores = [];
  final EventStore eventStore;

  AppStore({@required this.eventStore}) {
    _stores.add(this.eventStore);
  }


  void dispatch(ActionType type, action) {
    for (var store in _stores) {
      store.dispatch(type, action);
    }
  }

//  void dispatch1(Dispatcher dispatcher) {
//    dispatcher()
//  }
}