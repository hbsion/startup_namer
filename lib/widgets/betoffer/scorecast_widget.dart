import 'dart:async';

import 'package:flutter/material.dart';
import 'package:svan_play/api/offering_api.dart';
import 'package:svan_play/app_theme.dart';
import 'package:svan_play/data/betoffer.dart';
import 'package:svan_play/data/outcome.dart';
import 'package:svan_play/data/outcome_combination.dart';
import 'package:svan_play/widgets/betoffer/player_selection_widget.dart';
import 'package:svan_play/widgets/empty_widget.dart';
import 'package:svan_play/widgets/outcome_combo_widget.dart';
import 'package:svan_play/widgets/platform_circular_progress_indicator.dart';

class ScoreCastWidget extends StatefulWidget {
  final int betOfferId;
  final int eventId;

  const ScoreCastWidget({Key key, @required this.betOfferId, @required this.eventId})
      : assert(betOfferId != null),
        super(key: key);

  _ScoreCastWidgetState createState() => new _ScoreCastWidgetState();
}

class _ScoreCastWidgetState extends State<ScoreCastWidget> {
  Outcome _player;

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[_buildPlayerSelector(context), _buildResultOutcomes(context)],
    );
  }

  Widget _buildPlayerSelector(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: new RaisedButton(
          onPressed: () => _showPlayerDialog(context),
          color: AppTheme.of(context).brandColor,
          child: Text(
            _player != null ? _player.label : "Select Player",
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Widget _buildResultOutcomes(BuildContext context) {
    if (_player != null) {
      return new FutureBuilder<BetOffer>(
          future: fetchPlayerOutcomes(widget.betOfferId, _player.id), builder: _renderResultOutcomes);
    }

    return new EmptyWidget();
  }

  Widget _renderResultOutcomes(BuildContext context, AsyncSnapshot<BetOffer> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      var home = snapshot.data.combinableOutcomes.outcomeCombinations
          .where((oc) => int.parse(oc.resultOutcome.homeScore) > int.parse(oc.resultOutcome.awayScore))
          .toList()
            ..sort((a, b) => a.resultOutcome.homeScore.compareTo(b.resultOutcome.homeScore));
      var away = snapshot.data.combinableOutcomes.outcomeCombinations
          .where((oc) => int.parse(oc.resultOutcome.homeScore) < int.parse(oc.resultOutcome.awayScore))
          .toList()
            ..sort((a, b) => a.resultOutcome.awayScore.compareTo(b.resultOutcome.awayScore));
      var draw = snapshot.data.combinableOutcomes.outcomeCombinations
          .where((oc) => oc.resultOutcome.homeScore == oc.resultOutcome.awayScore)
          .toList()
            ..sort((a, b) => a.resultOutcome.homeScore.compareTo(b.resultOutcome.homeScore));

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildOutcomes(context, home),
          _buildOutcomes(context, draw),
          _buildOutcomes(context, away),
        ],
      );
    } else {
      return new Container(
        padding: EdgeInsets.all(8.0),
        child: new Center(
          child: new PlatformCircularProgressIndicator(),
        ),
      );
    }
  }

  Widget _buildOutcomes(BuildContext context, List<OutcomeCombination> outcomes) {
    return new Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: outcomes.map((oc) => new Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
          child: new OutcomeComboWidget(combo: oc),
        )).toList(),
      ),
    );
  }

  Future _showPlayerDialog(BuildContext context) async {
    Outcome player = await Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => new PlayerSelectionWidget(betOfferId: widget.betOfferId, eventId: widget.eventId)));

    if (player != null) {
      setState(() => _player = player);
    }
  }
}
