import 'package:flutter/material.dart';
import 'package:svan_play/app_theme.dart';

class ScoreCastWidget extends StatelessWidget {
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
    return new _PlayerWidget();
  }
}

class _PlayerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Player'),
        actions: [
          new FlatButton(
              onPressed: () {
                
              },
              child: new Text('SAVE', style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white))),
        ],
      ),
      body: new Text("Foo"),
    );
  }
}
