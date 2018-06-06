import 'dart:async';

import 'package:flutter/material.dart';
import 'package:svan_play/app_theme.dart';
import 'package:svan_play/data/outcome.dart';
import 'package:svan_play/widgets/betoffer/player_selection_widget.dart';

class ScoreCastWidget extends StatelessWidget {
  final int betOfferId;
  final int eventId;

  const ScoreCastWidget({Key key, @required this.betOfferId, @required this.eventId})
      : assert(betOfferId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Expanded(
            child: new RaisedButton(
                onPressed: () => _showDialog(context),
                color: AppTheme.of(context).brandColor,
                child: Text(
                  "Select Player",
                  style: TextStyle(color: Colors.white),
                ))),
      ],
    );
  }

  Future _showDialog(BuildContext context) async {
    //showDialog(context: context, builder: _buildDialog);
    Outcome player = await Navigator.of(context).push(MaterialPageRoute(fullscreenDialog: true, builder: _buildDialog));

    print(player);
  }

  Widget _buildDialog(BuildContext context) {
    return new PlayerSelectionWidget(betOfferId: betOfferId, eventId: eventId);
  }
}
