import 'dart:async';

import 'package:flutter/material.dart';
import 'package:svan_play/app_theme.dart';
import 'package:svan_play/data/outcome.dart';
import 'package:svan_play/util/callable.dart';
import 'package:svan_play/widgets/betoffer/cast/player_selection_dialog.dart';
import 'package:svan_play/widgets/empty_widget.dart';

class PlayerSelectorWidget extends StatelessWidget {
  final Callable<Outcome> onChanged;
  final int betOfferId;
  final int eventId;
  final Outcome player;

  const PlayerSelectorWidget({Key key, this.onChanged, this.betOfferId, this.eventId, this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new RaisedButton(
              onPressed: () => _showDialog(context),
              color: AppTheme.of(context).brandColor,
              child: Text(
                player?.label ?? "Select Player",
                style: TextStyle(color: Colors.white),
              )),
        ),
        player != null
            ? new IconButton(
                icon: new Icon(Icons.delete),
                onPressed: () => onChanged(null),
              )
            : new EmptyWidget()
      ],
    );
  }

  Future _showDialog(BuildContext context) async {
    Outcome player = await Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true, builder: (ctx) => new PlayerSelectionDialog(betOfferId: betOfferId, eventId: eventId)));

    if (player != null) {
      onChanged(player);
    }
  }
}
