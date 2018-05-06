import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/data/event_response.dart';
import 'package:startup_namer/data/event_stats.dart';
import 'package:startup_namer/data/match_clock.dart';
import 'package:startup_namer/data/score.dart';
import 'package:startup_namer/store/action_type.dart';
import 'package:startup_namer/store/store.dart';
import 'package:startup_namer/util/flowable.dart';

class StatisticsStore implements Store {
  final Map<int, BehaviorSubject<Score>> _scores = new HashMap();
  final Map<int, BehaviorSubject<MatchClock>> _matchClocks = new HashMap();
  final Map<int, BehaviorSubject<EventStats>> _eventStats = new HashMap();

  SnapshotObservable<Score> score(int eventId) {
    var subject = _scores[eventId];
    if (subject == null) {
      subject = new BehaviorSubject<Score>();
      _scores[eventId] = subject;
    }
    return new SnapshotObservable(subject.value, subject.observable);
  }

  SnapshotObservable<MatchClock> matchClock(int eventId) {
    var subject = _matchClocks[eventId];
    if (subject == null) {
      subject = new BehaviorSubject<MatchClock>();
      _matchClocks[eventId] = subject;
    }
    return new SnapshotObservable(subject.value, subject.observable);
  }

  SnapshotObservable<EventStats> eventStats(int eventId) {
    var subject = _eventStats[eventId];
    if (subject == null) {
      subject = new BehaviorSubject<EventStats>();
      _eventStats[eventId] = subject;
    }
    return new SnapshotObservable(subject.value, subject.observable);
  }

  @override
  void dispatch(ActionType type, action) {
    switch (type) {
      case ActionType.eventResponse:
        EventResponse response = action;
        for (var liveStats in response.liveStats) {
          _mergeScore(liveStats.eventId, liveStats.score);
          _mergeMatchClock(liveStats.eventId, liveStats.matchClock);
          _mergeEventStats(liveStats.eventId, liveStats.eventStats);
        }
        break;
      default:
        break;
    }
  }

  void _mergeScore(int eventId, Score score) {
    var subject = _scores[eventId];
    if (subject != null && subject.value != score && score != null) {
        subject.add(score);
    } else if (score != null) {
      _scores[eventId] = new BehaviorSubject<Score>(seedValue: score);
    }
  }

  void _mergeMatchClock(int eventId, MatchClock clock) {
    var subject = _matchClocks[eventId];
    if (subject != null && subject.value != clock && clock != null) {
        subject.add(clock);
    } else if (clock != null) {
      _matchClocks[eventId] = new BehaviorSubject<MatchClock>(seedValue: clock);
    }
  }

  void _mergeEventStats(int eventId, EventStats eventStats) {
    var subject = _eventStats[eventId];
    if (subject != null && subject.value != eventStats && eventStats != null) {
        subject.add(eventStats);
    } else if (eventStats != null) {
      _eventStats[eventId] = new BehaviorSubject<EventStats>(seedValue: eventStats);
    }
  }

}