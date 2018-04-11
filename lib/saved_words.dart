import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class SavedWords extends StatelessWidget {
  final Set<WordPair> saved;
  final TextStyle textStyle;

  SavedWords({this.saved, this.textStyle});

  @override
  Widget build(BuildContext context) {
    final tiles = saved.map(
      (pair) {
        return new ListTile(
          title: new Text(
            pair.asPascalCase,
            style: textStyle,
          ),
        );
      },
    );
    final divided = ListTile
        .divideTiles(
          context: context,
          tiles: tiles,
        )
        .toList();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Saved Suggestions'),
      ),
      body: new ListView(children: divided),
    );
  }
}
