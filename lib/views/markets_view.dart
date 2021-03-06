import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:svan_play/app_theme.dart';
import 'package:svan_play/data/betoffer.dart';
import 'package:svan_play/data/betoffer_categories.dart';
import 'package:svan_play/data/betoffer_category.dart';
import 'package:svan_play/data/betoffer_type.dart';
import 'package:svan_play/data/betoffer_types.dart';
import 'package:svan_play/data/criterion.dart';
import 'package:svan_play/store/actions.dart';
import 'package:svan_play/store/app_store.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/util/callable.dart';
import 'package:svan_play/widgets/betoffer/correct_score_widget.dart';
import 'package:svan_play/widgets/betoffer/goal_scorer_widget.dart';
import 'package:svan_play/widgets/betoffer/halftime_fulltime_widget.dart';
import 'package:svan_play/widgets/betoffer/handicap_widget.dart';
import 'package:svan_play/widgets/betoffer/head_to_head_widget.dart';
import 'package:svan_play/widgets/betoffer/main_betoffer_widget.dart';
import 'package:svan_play/widgets/betoffer/over_under_widget.dart';
import 'package:svan_play/widgets/betoffer/position_widget.dart';
import 'package:svan_play/widgets/betoffer/cast/scorecast_widget.dart';
import 'package:svan_play/widgets/betoffer/three_way_handicap_widget.dart';
import 'package:svan_play/widgets/betoffer/cast/wincast_widget.dart';
import 'package:svan_play/widgets/betoffer/winner_widget.dart';
import 'package:svan_play/widgets/empty_widget.dart';
import 'package:svan_play/widgets/list_section.dart';
import 'package:svan_play/widgets/platform_circular_progress_indicator.dart';
import 'package:svan_play/widgets/sticky_section_list_view.dart';

class MarketsView extends StatelessWidget {
  final int eventId;
  final String sport;
  final bool live;

  const MarketsView({Key key, @required this.eventId, @required this.live, @required this.sport})
      : assert(eventId != null),
        assert(live != null),
        assert(sport != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<_ViewModel>(
      stream: _mapStateToStream,
      initalData: _mapStateToInitialData,
      pollAction: _pollAction(),
      initAction: _initAction(),
      widgetBuilder: _buildWidget,
    );
  }

  Callable<Dispatcher> _pollAction() => (dispatcher) => betOffers(eventId)(dispatcher);

  Callable2<Dispatcher, AppStore> _initAction() {
    return (dispatcher, store) {
      if (!live && !store.categoryStore.has(sport, BetOfferCategories.preMatchEvent)) {
        categoryGroup(sport, BetOfferCategories.preMatchEvent)(dispatcher);
      } else if (live) {
        [BetOfferCategories.liveEvent, BetOfferCategories.selectedLive, BetOfferCategories.instantBetting]
            .forEach((categoryName) {
          if (!store.categoryStore.has(sport, categoryName)) {
            categoryGroup(sport, categoryName)(dispatcher);
          }
        });
      }
    };
  }

  Observable<_ViewModel> _mapStateToStream(AppStore store) {
    if (live) {
      return Observable.combineLatest4(
          store.betOfferStore.byEventId(eventId).observable,
          store.categoryStore.get(sport, BetOfferCategories.liveEvent).observable,
          store.categoryStore.get(sport, BetOfferCategories.selectedLive).observable,
          store.categoryStore.get(sport, BetOfferCategories.instantBetting).observable,
          (ids, categories, selected, instant) {
        return new _ViewModel(store.betOfferStore.snapshot(ids), categories,
            selectedCategories: selected, instantCategories: instant);
      });
    } else {
      return Observable.combineLatest2(
          store.betOfferStore.byEventId(eventId).observable,
          store.categoryStore.get(sport, BetOfferCategories.preMatchEvent).observable,
          (ids, categories) => new _ViewModel(store.betOfferStore.snapshot(ids), categories));
    }
  }

  _ViewModel _mapStateToInitialData(AppStore store) {
    var ids = store.betOfferStore.byEventId(eventId).latest;
    List<BetOffer> betoffers = ids != null ? store.betOfferStore.snapshot(ids) : null;

    if (live) {
      return new _ViewModel(betoffers, store.categoryStore.get(sport, BetOfferCategories.liveEvent).latest,
          selectedCategories: store.categoryStore.get(sport, BetOfferCategories.selectedLive).latest,
          instantCategories: store.categoryStore.get(sport, BetOfferCategories.instantBetting).latest);
    } else {
      return new _ViewModel(betoffers, store.categoryStore.get(sport, BetOfferCategories.preMatchEvent).latest);
    }
  }

  Widget _buildWidget(BuildContext context, _ViewModel model) {
    if (model == null ||
        model.betOffers == null ||
        model.categories == null ||
        model.selectedCategories == null ||
        model.instantCategories == null) {
      return Center(child: new PlatformCircularProgressIndicator());
    }

    return new StickySectionListView(key: Key("markets-$eventId"), sections: prepareData(context, model));
  }

  List<_BetOfferSection> prepareData(BuildContext context, _ViewModel model) {
    List<_BetOfferSection> sections = model.categories
        .where((category) => category.mappings.length > 0)
        .map((category) => filterAndGroupBetOffers(model.betOffers, category))
        .where((section) => section.groups.length > 0)
        .toList()
          ..sort((a, b) => a.category.sortOrder - b.category.sortOrder);

    // Instant
    if (model.instantCategories.length > 0) {
      var groups =
          _groupByCustomSelection(model.betOffers, model.instantCategories, onlyOnePerCategory: false).toList();
      if (groups.length > 0) {
        sections.insert(0, new _BetOfferSection(groups, model.instantCategories[0].withName("Instant Betting")));
      }
    }
    // Selected live
    if (model.selectedCategories.length > 0) {
      var groups = _groupByCustomSelection(model.betOffers, model.selectedCategories).toList();
      if (groups.length > 0) {
        sections.insert(0, new _BetOfferSection(groups, model.selectedCategories[0].withName("Selected Markets")));
      }
    }

    for (var section in sections) {
      section.trailing = new Text(section.groups.expand((g) => g.betOffers).length.toString(),
          style: TextStyle(color: AppTheme.of(context).list.headerForeground, fontWeight: FontWeight.w600));
    }
    if (sections.length > 0) {
      sections.first.initiallyExpanded = true;
    }

    return sections;
  }

  _BetOfferSection filterAndGroupBetOffers(List<BetOffer> betOffers, BetOfferCategory category) {
    var groups = betOffers
        .where((bo) => category.mappings.any((mapping) => mapping.criterionId == bo.criterion.id))
        .fold<List<_BetOfferGroup>>([], (groups, betoffer) {
      var group = groups.firstWhere(
          (g) =>
              g.criterion.id == betoffer.criterion.id &&
              g.criterion.label == betoffer.criterion.label &&
              g.type.id == betoffer.betOfferType.id,
          orElse: () => new _BetOfferGroup(betoffer.criterion, betoffer.betOfferType, []));
      if (group.betOffers.length == 0) {
        groups.add(group);
      }
      group.betOffers.add(betoffer);
      return groups;
    });
    groups.sort((bo1, bo2) => this.compareBetOffers(bo1, bo2, category));

    return new _BetOfferSection(groups, category);
  }

  Iterable<_BetOfferGroup> _groupByCustomSelection(List<BetOffer> betOffers, List<BetOfferCategory> categories,
      {bool onlyOnePerCategory = true}) sync* {
    categories.sort((a, b) => a.sortOrder - b.sortOrder);
    for (var category in categories) {
      var groups = _groupByCategory(betOffers, category);
      if (groups.length > 0) {
        if (onlyOnePerCategory && groups.length > 1) {
          var nonSuspended = groups.where((group) => !group.betOffers.every((bo) => bo.suspended));
          if (nonSuspended.isNotEmpty) {
            yield nonSuspended.last;
          } else {
            yield groups.last;
          }
        } else {
          yield* groups;
        }
      }
    }
  }

  Iterable<_BetOfferGroup> _groupByCategory(List<BetOffer> betOffers, BetOfferCategory category) sync* {
    if (category.mappings != null) {
      for (var bo in betOffers) {
        if (category.mappings.any((mapping) => mapping.criterionId == bo.criterion.id)) {
          yield new _BetOfferGroup(bo.criterion, bo.betOfferType, [bo]);
        }
      }
    }
  }

  int compareBetOffers(_BetOfferGroup group1, _BetOfferGroup group2, BetOfferCategory category) {
    var mappingBo1 =
        category.mappings.firstWhere((mapping) => mapping.criterionId == group1.criterion.id, orElse: () => null);
    var mappingBo2 =
        category.mappings.firstWhere((mapping) => mapping.criterionId == group2.criterion.id, orElse: () => null);

    if (mappingBo1 != null && mappingBo2 != null) {
      return (mappingBo1.sortOrder ?? 0) - (mappingBo2.sortOrder ?? 0);
    }
    if (mappingBo1 == null && mappingBo2 != null) {
      return -1;
    }
    if (mappingBo1 != null && mappingBo2 == null) {
      return 1;
    }

    return 0;
  }
}

class _BetOfferSection extends ListSection {
  final List<_BetOfferGroup> groups;
  final BetOfferCategory category;
  bool _initiallyExpanded = false;

  _BetOfferSection(this.groups, this.category);

  @override
  IndexedWidgetBuilder get builder => _buildRow;

  @override
  int get count => groups.length;

  @override
  bool get initiallyExpanded => _initiallyExpanded;

  set initiallyExpanded(bool value) => _initiallyExpanded = value;

  @override
  String get title => category.name;

  Widget _buildRow(BuildContext context, int index) {
    var group = groups[index];
    var extra = group.betOffers[0].extra;

    return new Container(
        padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: new Text(group.criterion.label, style: TextStyle(fontSize: 16.0)),
            ),
            extra == null
                ? new EmptyWidget()
                : new Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                    child: new Text(extra,
                        style: Theme.of(context).textTheme.caption.merge(TextStyle(fontStyle: FontStyle.italic))),
                  ),
            _renderGroup(context, group)
          ],
        ));
  }

  Widget _renderGroup(BuildContext context, _BetOfferGroup group) {
    switch (group.type.id) {
      case BetOfferTypes.overUnder:
      case BetOfferTypes.asianOverUnder:
        return new OverUnderWidget(
          eventId: group.betOffers.first.eventId,
          outcomeIds: group.betOffers.expand((bo) => bo.outcomes).toList(),
        );
      case BetOfferTypes.handicap:
      case BetOfferTypes.asianHandicap:
        return new HandicapWidget(
          eventId: group.betOffers.first.eventId,
          outcomeIds: group.betOffers.expand((bo) => bo.outcomes).toList(),
        );
      case BetOfferTypes.correctScore:
        return new CorrectScoreWidget(
          eventId: group.betOffers.first.eventId,
          outcomeIds: group.betOffers.expand((bo) => bo.outcomes).toList(),
        );
      case BetOfferTypes.threeWayHandicap:
        return new ThreeWayHandicapWidget(
          eventId: group.betOffers.first.eventId,
          outcomeIds: group.betOffers.expand((bo) => bo.outcomes).toList(),
        );
      case BetOfferTypes.goalScorer:
        return new GoalScorerWidget(
          eventId: group.betOffers.first.eventId,
          outcomeIds: group.betOffers.expand((bo) => bo.outcomes).toList(),
        );
      case BetOfferTypes.halfTimeFullTime:
        return new HalfTimeFullTimeWidget(
          eventId: group.betOffers.first.eventId,
          outcomeIds: group.betOffers.expand((bo) => bo.outcomes).toList(),
        );
      case BetOfferTypes.headToHead:
        return new HeadToHeadWidget(
          eventId: group.betOffers.first.eventId,
          outcomeIds: group.betOffers.expand((bo) => bo.outcomes).toList(),
        );
      case BetOfferTypes.winner:
        return new WinnerWidget(
          eventId: group.betOffers.first.eventId,
          outcomeIds: group.betOffers.expand((bo) => bo.outcomes).toList(),
        );
      case BetOfferTypes.position:
        return new PositionWidget(
          eventId: group.betOffers.first.eventId,
          outcomeIds: group.betOffers.expand((bo) => bo.outcomes).toList(),
        );
      case BetOfferTypes.scoreCast:
        return new ScoreCastWidget(betOfferId: group.betOffers.first.id, eventId: group.betOffers.first.eventId);
      case BetOfferTypes.winCast:
        return new WinCastWidget(
          betOfferId: group.betOffers.first.id,
          eventId: group.betOffers.first.eventId
        );
    }
    if (group.type.id == BetOfferTypes.scoreCast || group.type.id == BetOfferTypes.winCast) {
      return new Text('${group.criterion.label}(${group.criterion.id}) ${group.type.name} '
          '(${group.type.id}) #${group.betOffers.length} susp: ${group.betOffers[0].suspended}');
    }

    return new Column(
        children: group.betOffers
            .map((bo) => new Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: new MainBetOfferWidget(
                    betOfferId: bo.id, eventId: bo.eventId, defaultOrientation: Orientation.portrait)))
            .toList());
  }
}

class _BetOfferGroup {
  final Criterion criterion;
  final BetOfferType type;
  final List<BetOffer> betOffers;

  _BetOfferGroup(this.criterion, this.type, this.betOffers);
}

class _ViewModel {
  final List<BetOffer> betOffers;
  final List<BetOfferCategory> categories;
  final List<BetOfferCategory> selectedCategories;
  final List<BetOfferCategory> instantCategories;

  _ViewModel(this.betOffers, this.categories, {this.selectedCategories = const [], this.instantCategories = const []});

  @override
  bool operator ==(Object other) {
    // used for should update
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;

    _ViewModel otherModel = other;
    if (!const ListEquality().equals(
        betOffers?.map((bo) => bo.id)?.toList(), otherModel?.betOffers?.map((bo) => bo.id)?.toList())) return false;
    if (!const ListEquality().equals(categories, otherModel.categories)) return false;
    if (!const ListEquality().equals(selectedCategories, otherModel.selectedCategories)) return false;
    if (!const ListEquality().equals(instantCategories, otherModel.instantCategories)) return false;

    return true;
  }
}
