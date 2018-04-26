import 'package:startup_namer/store/action_type.dart';
import 'package:startup_namer/store/event_collection_store.dart';
import 'package:startup_namer/store/event_store.dart';
import 'package:startup_namer/store/store.dart';

typedef Dispatcher = void Function(ActionType type, dynamic action);

class AppStore {
  final List<Store> _stores = [];
  final EventStore eventStore = new EventStore();
  final EventCollectionStore collectionStore = new EventCollectionStore();

  AppStore() {
    _stores..add(eventStore)..add(collectionStore);
  }

  void dispatch(ActionType type, action) {
    _stores.forEach((store) => store.dispatch(type, action));
  }
}