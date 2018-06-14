import 'dart:collection';

import 'package:rxdart/rxdart.dart';
import 'package:svan_play/data/event_response.dart';
import 'package:svan_play/data/event_stats.dart';
import 'package:svan_play/data/live_stats.dart';
import 'package:svan_play/data/match_clock.dart';
import 'package:svan_play/data/match_occurence.dart';
import 'package:svan_play/data/push/event_stats_update.dart';
import 'package:svan_play/data/push/match_clock_update.dart';
import 'package:svan_play/data/push/score_update.dart';
import 'package:svan_play/data/score.dart';
import 'package:svan_play/store/action_type.dart';
import 'package:svan_play/store/store.dart';
import 'package:svan_play/store/store_util.dart';
import 'package:svan_play/util/flowable.dart';

class StatisticsStore implements Store {
  final Map<int, BehaviorSubject<Score>> _scores = new HashMap();
  final Map<int, BehaviorSubject<MatchClock>> _matchClocks = new HashMap();
  final Map<int, BehaviorSubject<EventStats>> _eventStats = new HashMap();
  final Map<int, BehaviorSubject<List<MatchOccurence>>> _matchOccurences = new HashMap();

  SnapshotObservable<Score> score(int eventId) {
    return getOrCreateSubject(eventId, _scores);
  }

  SnapshotObservable<MatchClock> matchClock(int eventId) {
    return getOrCreateSubject(eventId, _matchClocks);
  }

  SnapshotObservable<EventStats> eventStats(int eventId) {
    return getOrCreateSubject(eventId, _eventStats);
  }

  SnapshotObservable<List<MatchOccurence>> matchOccurences(int eventId) {
    return getOrCreateSubject(eventId, _matchOccurences);
  }

  @override
  void dispatch(ActionType type, action) {
    switch (type) {
      case ActionType.eventResponse:
        EventResponse response = action;
        for (var liveStats in response.liveStats) {
          _mergeLiveStats(liveStats);
        }
        break;
      case ActionType.liveStats:
        _mergeLiveStats(action);
        break;
      case ActionType.matchClockUpdate:
        MatchClockUpdate update = action;
        merge(update.eventId, update.matchClock, _matchClocks, ignoreIfNotFound: true);
        break;
      case ActionType.scoreUpdate:
        ScoreUpdate update = action;
        merge(update.eventId, update.score, _scores);
        break;
      case ActionType.eventStatsUpdate:
        EventStatsUpdate update = action;
        merge(update.eventId, update.eventStats, _eventStats);
        break;
      case ActionType.matchOccurenceAdded:
        MatchOccurence mo = action;
        _mergeMatchOccurence(mo);
        break;
      default:
        break;
    }
  }

  void _mergeLiveStats(LiveStats liveStats) {
    if (liveStats != null) {
      merge(liveStats.eventId, liveStats.score, _scores);
      merge(liveStats.eventId, liveStats.matchClock, _matchClocks);
      merge(liveStats.eventId, liveStats.eventStats, _eventStats);
      merge(liveStats.eventId, liveStats.occurences, _matchOccurences);
    }
  }

  void _mergeMatchOccurence(MatchOccurence mo) {
    if (mo != null) {
      var occurences = _matchOccurences[mo.eventId];
      if (occurences?.value != null) {
        merge(mo.eventId, List.from(occurences.value)..add(mo), _matchOccurences);
      }
    }
  }
}
