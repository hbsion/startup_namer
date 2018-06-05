import 'package:flutter/material.dart';
import 'package:svan_play/app_theme.dart';
import 'package:svan_play/data/betoffer.dart';
import 'package:svan_play/data/event.dart';
import 'package:svan_play/store/store_connector.dart';

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

  void _showDialog(BuildContext context) {
    //showDialog(context: context, builder: _buildDialog);
    Navigator.of(context).push(MaterialPageRoute(fullscreenDialog: true, builder: _buildDialog));
  }

  Widget _buildDialog(BuildContext context) {
    return new _PlayerCastWidget(betOfferId: betOfferId, eventId: eventId);
  }
}

class _PlayerCastWidget extends StatelessWidget {
  final int betOfferId;
  final int eventId;

  const _PlayerCastWidget({Key key, @required this.betOfferId, @required this.eventId})
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
    return new Column(
      children: _buildTeams(context, model).toList(),
    );
  }

  Iterable<Widget> _buildTeams(BuildContext context, _ViewModel model) sync * {
    yield new Row(
      children: <Widget>[
        _buildTeamHeader(model.event.homeName),
        _buildTeamHeader(model.event.awayName),
      ],
    );
  }

  Expanded _buildTeamHeader(String name) {
    return Expanded(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: new Center(child: Text(name)),
        ),
      );
  }
}

class _ViewModel {
  final BetOffer betOffer;
  final Event event;

  _ViewModel(this.betOffer, this.event);
}