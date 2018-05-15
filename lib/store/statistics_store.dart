import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:svan_play/data/event_response.dart';
import 'package:svan_play/data/event_stats.dart';
import 'package:svan_play/data/match_clock.dart';
import 'package:svan_play/data/push/event_stats_update.dart';
import 'package:svan_play/data/push/match_clock_update.dart';
import 'package:svan_play/data/push/score_update.dart';
import 'package:svan_play/data/score.dart';
import 'package:svan_play/store/action_type.dart';
import 'package:svan_play/store/store.dart';
import 'package:svan_play/util/flowable.dart';

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
    return new SnapshotObservable(subject.value, subject.stream);
  }

  SnapshotObservable<MatchClock> matchClock(int eventId) {
    var subject = _matchClocks[eventId];
    if (subject == null) {
      subject = new BehaviorSubject<MatchClock>();
      _matchClocks[eventId] = subject;
    }
    return new SnapshotObservable(subject.value, subject.stream);
  }

  SnapshotObservable<EventStats> eventStats(int eventId) {
    var subject = _eventStats[eventId];
    if (subject == null) {
      subject = new BehaviorSubject<EventStats>();
      _eventStats[eventId] = subject;
    }
    return new SnapshotObservable(subject.value, subject.stream);
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
      case ActionType.matchClockUpdate:
        MatchClockUpdate update = action;
        _mergeMatchClock(update.eventId, update.matchClock, ignoreIfNotFound: true);
        break;
      case ActionType.scoreUpdate:
        ScoreUpdate update = action;
        _mergeScore(update.eventId, update.score);
        break;
      case ActionType.eventStatsUpdate:
        EventStatsUpdate update = action;
        _mergeEventStats(update.eventId, update.eventStats);
        break;
      default:
        break;
    }
  }

  void _mergeScore(int eventId, Score score, {bool ignoreIfNotFound = false}) {
    var subject = _scores[eventId];
    if (subject != null) {
      if (subject.value != score && score != null) {
        subject.add(score);
      }
    } else if (score != null) {
      _scores[eventId] = new BehaviorSubject<Score>(seedValue: score);
    }
  }

  void _mergeMatchClock(int eventId, MatchClock clock, {bool ignoreIfNotFound = false}) {
    var subject = _matchClocks[eventId];
    if (subject != null) {
      if (subject.value != clock && clock != null) {
        subject.add(clock);
      }
    } else if (clock != null && !ignoreIfNotFound) {
      _matchClocks[eventId] = new BehaviorSubject<MatchClock>(seedValue: clock);
    }
  }

  void _mergeEventStats(int eventId, EventStats eventStats, {bool ignoreIfNotFound = false}) {
    var subject = _eventStats[eventId];
    if (subject != null) {
      if (subject.value != eventStats && eventStats != null) {
        subject.add(eventStats);
      }
    } else if (eventStats != null && !ignoreIfNotFound) {
      _eventStats[eventId] = new BehaviorSubject<EventStats>(seedValue: eventStats);
    }
  }

}