import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:svan_play/api/offering_api.dart';
import 'package:svan_play/data/betoffer.dart';
import 'package:svan_play/data/event.dart';
import 'package:svan_play/data/outcome.dart';
import 'package:svan_play/data/outcome_combination.dart';
import 'package:svan_play/data/outcome_type.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/widgets/betoffer/cast/player_selector_widget.dart';
import 'package:svan_play/widgets/empty_widget.dart';
import 'package:svan_play/widgets/outcome_combo_widget.dart';
import 'package:svan_play/widgets/platform_circular_progress_indicator.dart';

class WinCastWidget extends StatefulWidget {
  final int betOfferId;
  final int eventId;

  const WinCastWidget({Key key, @required this.betOfferId, @required this.eventId})
      : assert(betOfferId != null),
        super(key: key);

  _WinCastWidgetState createState() => new _WinCastWidgetState();
}

class _WinCastWidgetState extends State<WinCastWidget> {
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
      child: new PlayerSelectorWidget(
        betOfferId: widget.betOfferId,
        eventId: widget.eventId,
        player: _player,
        onChanged: (player) => setState(() => _player = player),
      ),
    );
  }

  Widget _buildResultOutcomes(BuildContext context) {
    if (_player != null) {
      return new StoreConnector<Event>(
        initalData: (store) => store.eventStore[widget.eventId].latest,
        widgetBuilder: (context, event) => new FutureBuilder<BetOffer>(
            future: fetchPlayerOutcomes(widget.betOfferId, _player.id),
            builder: (context, snapshot) => _renderWinOutcomes(context, snapshot, event)),
      );
    }

    return new EmptyWidget();
  }

  Widget _renderWinOutcomes(BuildContext context, AsyncSnapshot<BetOffer> snapshot, Event event) {
    if (snapshot.connectionState == ConnectionState.done) {
      return Row(
        children: snapshot.data.combinableOutcomes.outcomeCombinations
            .map((oc) => new Expanded(
                    child: new Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: new OutcomeComboWidget(combo: oc, label: _resolveLabel(oc, event)),
                )))
            .toList(),
      );
    } else {
      return _renderSpinner();
    }
  }

  Container _renderSpinner() {
    return new Container(
      padding: EdgeInsets.all(8.0),
      child: new Center(
        child: new PlatformCircularProgressIndicator(),
      ),
    );
  }

  String _resolveLabel(OutcomeCombination oc, Event event) {
    if (oc.resultOutcome.type == OutcomeType.WC_HOME) {
      return event.homeName;
    } else if (oc.resultOutcome.type == OutcomeType.WC_AWAY) {
      return event.awayName;
    }

    return null;
  }
}
