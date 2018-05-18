import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:svan_play/data/betoffer_category.dart';
import 'package:svan_play/data/betoffer_category_response.dart';
import 'package:svan_play/data/event_response.dart';
import 'package:svan_play/data/event_collection.dart';
import 'package:svan_play/data/event_collection_key.dart';
import 'package:svan_play/store/action_type.dart';
import 'package:svan_play/store/store.dart';
import 'package:svan_play/util/flowable.dart';
import 'package:tuple/tuple.dart';


class BetOfferCategoryStore implements Store {
  final Map<Tuple2<int, String>, BehaviorSubject<List<BetOfferCategory>>> _categories = new HashMap();

  SnapshotObservable<List<BetOfferCategory>> get(int groupId, String categoryName) {
    var key = Tuple2(groupId, categoryName.toLowerCase());
    var subject = _categories[key];
    if (subject == null) {
      subject = new BehaviorSubject<List<BetOfferCategory>>();
      _categories[key] = subject;
    }
    return new SnapshotObservable(subject.value, subject.stream);
  }

  bool has(int groupId, String categoryName) {
    var subject = _categories[Tuple2(groupId, categoryName.toLowerCase())];
    return subject != null && subject.value != null;
  }

  @override
  void dispatch(ActionType type, action) {
    switch (type) {
      case ActionType.categoryResponse:
        BetOfferCategoryResponse response = action;
        var key = Tuple2(response.groupId, response.categoryName.toLowerCase());

        var subject = _categories[key];
        if (subject != null) {
            subject.add(response.categories);
        } else {
          _categories[key] = new BehaviorSubject<List<BetOfferCategory>>(seedValue: response.categories);
        }
        break;

      default:
        break;
    }
  }

}