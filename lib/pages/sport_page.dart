import 'package:flutter/material.dart';
import 'package:startup_namer/app_drawer.dart';
import 'package:startup_namer/widgets/app_toolbar.dart';
import 'package:startup_namer/widgets/event_list_widget.dart';
import 'package:startup_namer/widgets/section_header.dart';
import 'package:startup_namer/widgets/section_list_view.dart';

List<ListSection> tiles = buildSections();

List<ListSection> buildSections() {
  List<ListSection> data = [];

  for (int i = 0; i < 200; i++) {
    data.add(buildTile(i));
  }
  return data;
}

ListSection buildTile(int i) {
  ListSection tile = new ListSection(
    initiallyExpanded: i == 0,
    title: "Tile-" + i.toString(),
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

//final Map<Key, bool> expanded = Map();

Widget buildRow(int section, int row) {
  return new EventListItemWidget(key: Key("$section - $row"),);
}

class SportPage extends StatelessWidget {
  final String title;

  SportPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new CustomScrollView(
          slivers: <Widget>[
            new AppToolbar(title: "Sport"),
            new SectionListView(sections: tiles)
          ],
        ),
        drawer: new AppDrawer()
    );
  }
}
