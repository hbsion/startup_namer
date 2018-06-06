import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:svan_play/app_theme.dart';
import 'package:svan_play/data/betoffer.dart';
import 'package:svan_play/data/event.dart';
import 'package:svan_play/data/outcome.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/widgets/empty_widget.dart';

class PlayerSelectionWidget extends StatelessWidget {
  final int betOfferId;
  final int eventId;

  const PlayerSelectionWidget({Key key, @required this.betOfferId, @required this.eventId})
      : assert(betOfferId != null),
        assert(eventId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<_ViewModel>(
      initalData: (store) => _ViewModel(store.betOfferStore[betOfferId].latest, store.eventStore[eventId].latest),
      widgetBuilder: _buildWidget,
    );
  }

  Widget _buildWidget(BuildContext context, _ViewModel model) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Player'),
      ),
      body: _buildBody(context, model),
    );
  }

  Widget _buildBody(BuildContext context, _ViewModel model) {
    return new ListView(
      children: <Widget>[_buildTeams(context, model)],
    );
  }

  StickyHeader _buildTeams(BuildContext context, _ViewModel model) {
    return new StickyHeader(
        header: new Container(
          color: AppTheme.of(context).list.headerBackground,
          child: new Row(
            children: <Widget>[
              _buildTeamHeader(context, model.event.homeName),
              _buildTeamHeader(context, model.event.awayName),
            ],
          ),
        ),
        content: new Container(
          child: new Column(
            children: _buildTeamMembers(context, model).toList(),
          ),
        ));
  }

  Iterable<Row> _buildTeamMembers(BuildContext context, _ViewModel model) sync* {
    List<Outcome> homeMembers = model.betOffer.combinableOutcomes.playerOutcomes.where((p) => p.homeTeamMember).toList()
      ..sort((a, b) => a.label.compareTo(b.label));
    List<Outcome> awayMembers = model.betOffer.combinableOutcomes.playerOutcomes
        .where((p) => !p.homeTeamMember)
        .toList()
          ..sort((a, b) => a.label.compareTo(b.label));

    for (var i = 0; i < max(homeMembers.length, awayMembers.length); ++i) {
      var homePlayer = i < homeMembers.length ? homeMembers[i] : null;
      var awayPlayer = i < awayMembers.length ? awayMembers[i] : null;

      yield new Row(
        children: <Widget>[
          _buildTeamMember(context, homePlayer),
          _buildTeamMember(context, awayPlayer),
        ],
      );
    }
  }

  Widget _buildTeamHeader(BuildContext context, String name) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: new Center(
            child: Text(
          name,
          style: TextStyle(fontSize: 16.0, color: AppTheme.of(context).list.headerForeground),
        )),
      ),
    );
  }

  Widget _buildTeamMember(BuildContext context, Outcome player) {
    if (player == null) {
      return new Expanded(child: new EmptyWidget());
    }
    return new Expanded(
      child: new Padding(
        padding: const EdgeInsets.all(2.0),
        child: _PlayerWidget(
          player: player,
        ),
      ),
    );
  }
}

class _ViewModel {
  final BetOffer betOffer;
  final Event event;

  _ViewModel(this.betOffer, this.event);
}

class _PlayerWidget extends StatelessWidget {
  final Outcome player;

  const _PlayerWidget({Key key, this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
        height: 38.0,
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          color: AppTheme.of(context).outcome.background(),
        ),
        child: new Material(
          color: Colors.transparent,
          child: new InkWell(
              onTap: () => Navigator.of(context).pop(player),
              child: new Container(
                alignment: Alignment.centerLeft,
                child: new Text(
                  player.label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white),
                ),
              )),
        ));
  }
}
