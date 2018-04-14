import 'package:flutter/material.dart';
import 'package:startup_namer/widgets/event_list_widget.dart';

List<SportSection> tiles = buildTiles();

List<SportSection> buildTiles() {
  List<SportSection> data = [];

  for (int i = 0; i < 200; i++) {
    data.add(buildTile(i));
  }
  return data;
}

SportSection buildTile(int i) {
  SportSection tile = new SportSection(
    key: new Key(i.toString()),
    initiallyExpanded: i == 0,
    title: new Text("Tile-" + i.toString()),
    children: buildRows(i),
  );

  return tile;
}

List<Widget> buildRows(int section) {
  List<Widget> data = [];

  for (int row = 0; row < 5; row++) {
    data.add(buildRow(section, row));
  }

  return data;
}

final Map<Key, bool> expanded = Map();

Widget buildRow(int section, int row) {
  return new EventListItemWidget();
}

class SportSection extends StatefulWidget {
  final List<Widget> children;
  final bool initiallyExpanded;
  final Widget title;

  const SportSection({Key key, this.initiallyExpanded, this.children, this.title}) : super(key: key);

  @override
  SportSectionState createState() => SportSectionState(children, initiallyExpanded, title, key);
}

class SportSectionState extends State<SportSection> {
  final List<Widget> children;
  final bool initiallyExpanded;
  final Widget title;
  final Key key;
  bool _expanded;

  SportSectionState(this.children, this.initiallyExpanded, this.title, this.key);

  @override
  void initState() {
    if (!expanded.containsKey(key)) {
      expanded[key] = initiallyExpanded;
    }

    _expanded = expanded[key];
  }

  @override
  Widget build(BuildContext context) {
    var sectionHeader = new InkWell(
      onTap: () =>  setState(() {
        _expanded = !_expanded;
        expanded[key] = _expanded;
      }),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: new Row(children: <Widget>[title]),
      ),
    );
    List<Widget> widgets = [];
    widgets.add(sectionHeader);

    if (_expanded) {
      widgets.addAll(children);
    }

    return new Column(
        children: widgets
    );
//    return new ExpansionTile(
//      title: title,
//      children: children,
//      initiallyExpanded: _expanded,
//      onExpansionChanged: (expanded) => _expanded = expanded,
//    );
  }
}

class SportPage extends StatelessWidget {
  final String title;

  SportPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: tiles,
    );
  }
}
