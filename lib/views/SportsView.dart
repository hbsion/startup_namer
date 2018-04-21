import 'package:flutter/material.dart';
import 'package:startup_namer/widgets/event_list_widget.dart';
import 'package:startup_namer/widgets/section_list_view.dart';

class SportView extends StatefulWidget {
  final String sport;
  final String league;
  final String region;
  final String prefix;

  const SportView({Key key, this.sport, this.league, this.region, this.prefix}) : super(key: key);

  @override
  _SportViewState createState() => new _SportViewState();
}

class _SportViewState extends State<SportView> {
  @override
  Widget build(BuildContext context) {
    return new SectionListView(
        key: new PageStorageKey(widget.prefix),
        sections: buildSections(widget.prefix));
  }
}


List<ListSection> buildSections(String prefix) {
  List<ListSection> data = [];

  for (int i = 0; i < 200; i++) {
    data.add(buildTile(i, prefix));
  }
  return data;
}

ListSection buildTile(int i, String prefix) {
  ListSection tile = new ListSection(
    initiallyExpanded: i == 0,
    title: prefix + "-" + i.toString(),
    children: buildRows(i),
  );

  return tile;
}

List<Widget> buildRows(int section) {
  List<Widget> data = [];

  for (int row = 0; row < 100; row++) {
    data.add(buildRow(section, row));
  }

  return data;
}

Widget buildRow(int section, int row) {
  return new EventListItemWidget(key: Key("$section - $row"),);
}
