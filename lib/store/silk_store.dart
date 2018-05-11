import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/data/silk_image.dart';
import 'package:startup_namer/data/silk_response.dart';
import 'package:startup_namer/store/action_type.dart';
import 'package:startup_namer/store/store.dart';
import 'package:startup_namer/util/flowable.dart';

class SilkStore implements Store {
  final Map<int, BehaviorSubject<List<SilkImage>>> _silks = new HashMap();
  final Set<int> _silksLoaded = new HashSet();

  SnapshotObservable<List<SilkImage>> operator [](int eventId) {
    var subject = _silks[eventId];
    if (subject == null) {
      subject = new BehaviorSubject<List<SilkImage>>();
      _silks[eventId] = subject;
    }
    return new SnapshotObservable(subject.value, subject.stream);
  }

  bool hasSilks(int eventId) => _silksLoaded.contains(eventId);

  void silkLoading(int eventId) => _silksLoaded.add(eventId);

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
