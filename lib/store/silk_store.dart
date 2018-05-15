import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:svan_play/data/silk_image.dart';
import 'package:svan_play/data/silk_response.dart';
import 'package:svan_play/store/action_type.dart';
import 'package:svan_play/store/store.dart';
import 'package:svan_play/util/flowable.dart';

class SilkStore implements Store {
  final Map<int, BehaviorSubject<List<SilkImage>>> _silks = new HashMap();

  SnapshotObservable<List<SilkImage>> operator [](int eventId) {
    var subject = _silks[eventId];
    if (subject == null) {
      subject = new BehaviorSubject<List<SilkImage>>();
      _silks[eventId] = subject;
    }
    return new SnapshotObservable(subject.value, subject.stream);
  }

  bool hasSilks(int eventId) {
    var subject = _silks[eventId];
    return subject != null && subject.value != null;
  }

  @override
  void dispatch(ActionType type, action) {
    switch (type) {
      case ActionType.silkResponse:
        SilkResponse response = action;
        var subject = _silks[response.eventId];
        if (subject != null) {
          subject.add(response.silks);
        } else {
          _silks[response.eventId] = new BehaviorSubject<List<SilkImage>>(seedValue: response.silks);
        }
        break;
      default:
        break;
    }
  }
}
