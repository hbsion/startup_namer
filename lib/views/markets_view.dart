import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
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
import 'package:svan_play/widgets/betoffer/main_betoffer_widget.dart';
import 'package:svan_play/widgets/platform_circular_progress_indicator.dart';
import 'package:svan_play/widgets/section_list_view.dart';

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
    var ids = store.betOfferStore.byEventId(eventId).last;
    List<BetOffer> betoffers = ids != null ? store.betOfferStore.snapshot(ids) : null;

    if (live) {
      return new _ViewModel(betoffers, store.categoryStore.get(sport, BetOfferCategories.liveEvent).last,
          selectedCategories: store.categoryStore.get(sport, BetOfferCategories.selectedLive).last,
          instantCategories: store.categoryStore.get(sport, BetOfferCategories.instantBetting).last);
    } else {
      return new _ViewModel(betoffers, store.categoryStore.get(sport, BetOfferCategories.preMatchEvent).last);
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

    debugPrint("Rendering marketsview");
    return new SectionListView(key: Key("markets-$eventId"), asSliver: false, sections: prepareData(model));
  }

  List<_BetOfferSection> prepareData(_ViewModel model) {
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
          }
          yield groups.last;
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

  _BetOfferSection(this.groups, this.category);

  @override
  IndexedWidgetBuilder get builder => _buildRow;

  @override
  int get count => groups.length;

  @override
  bool get initiallyExpanded => true;

  @override
  String get title => category.name;

  Widget _buildRow(BuildContext context, int index) {
    var group = groups[index];

    return new Container(
        padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: new Text(group.criterion.label, style: TextStyle(fontSize: 16.0)),
            ),
            _renderGroup(context, group)
          ],
        ));
  }

  Widget _renderGroup(BuildContext context, _BetOfferGroup group) {
    if (group.type.id == BetOfferTypes.overUnder ||
        group.type.id == BetOfferTypes.correctScore ||
        group.type.id == BetOfferTypes.winner ||
        group.type.id == BetOfferTypes.position ||
        group.type.id == BetOfferTypes.handicap ||
        group.type.id == BetOfferTypes.goalScorer ||
        group.type.id == BetOfferTypes.threeWayHandicap ||
        group.type.id == BetOfferTypes.asianHandicap ||
        group.type.id == BetOfferTypes.asianOverUnder ||
        group.type.id == BetOfferTypes.headToHead ||
        group.type.id == BetOfferTypes.halfTimeFullTime) {
      return new Text('${group.criterion.label}(${group.criterion.id}) ${group.type.name} '
          '(${group.type.id}) #${group.betOffers.length} susp: ${group.betOffers[0].suspended}');

//        return (
//            <BetOfferGroupItem eventId={this.props.eventId}
//                               type={group.type}
//                               betOfferIds={group.betoffers.map(bo => bo.id)}
//                               outcomeIds={flatMap(group.betoffers.map(bo => bo.outcomes))}/>
//        )
    }

    return new Column(
        children: group.betOffers
            .map((bo) => new Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: new MainBetOfferWidget(betOfferId: bo.id, eventId: bo.eventId)))
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
