import 'package:svan_play/store/action_type.dart';
import 'package:svan_play/store/betoffer_category_store.dart';
import 'package:svan_play/store/betoffer_store.dart';
import 'package:svan_play/store/event_collection_store.dart';
import 'package:svan_play/store/event_store.dart';
import 'package:svan_play/store/favorites_store.dart';
import 'package:svan_play/store/groups_store.dart';
import 'package:svan_play/store/outcome_store.dart';
import 'package:svan_play/store/silk_store.dart';
import 'package:svan_play/store/statistics_store.dart';
import 'package:svan_play/store/store.dart';

typedef Dispatcher = void Function(ActionType type, dynamic action);

class AppStore {
  final List<Store> _stores = [];
  final EventStore eventStore = new EventStore();
  final BetOfferStore betOfferStore = new BetOfferStore();
  final OutcomeStore outcomeStore = new OutcomeStore();
  final GroupStore groupStore = new GroupStore();
  final FavoritesStore favoritesStore = new FavoritesStore();
  final StatisticsStore statisticsStore = new StatisticsStore();
  final EventCollectionStore collectionStore = new EventCollectionStore();
  final SilkStore silkStore = new SilkStore();
  final BetOfferCategoryStore categoryStore = new BetOfferCategoryStore();

  AppStore() {
    _stores
      ..add(eventStore)
      ..add(outcomeStore)
      ..add(betOfferStore)
      ..add(favoritesStore)
      ..add(groupStore)
      ..add(statisticsStore)
      ..add(silkStore)
      ..add(collectionStore)
      ..add(categoryStore);
  }

  void dispatch(ActionType type, action) {
    _stores.forEach((store) => store.dispatch(type, action));
  }
}
