import 'package:startup_namer/store/action_type.dart';
import 'package:startup_namer/store/betoffer_store.dart';
import 'package:startup_namer/store/event_collection_store.dart';
import 'package:startup_namer/store/event_store.dart';
import 'package:startup_namer/store/outcome_store.dart';
import 'package:startup_namer/store/store.dart';

typedef Dispatcher = void Function(ActionType type, dynamic action);

class AppStore {
  final List<Store> _stores = [];
  final EventStore eventStore = new EventStore();
  final BetOfferStore betOfferStore = new BetOfferStore();
  final OutcomeStore outcomeStore = new OutcomeStore();

  EventCollectionStore _collectionStore;

  AppStore() {
    _collectionStore = new EventCollectionStore();
    _stores..add(eventStore)
      ..add(betOfferStore)
      ..add(outcomeStore)
      ..add(_collectionStore);
  }

  EventCollectionStore get collectionStore => _collectionStore;

  void dispatch(ActionType type, action) {
    _stores.forEach((store) => store.dispatch(type, action));
  }
}