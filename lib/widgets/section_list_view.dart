import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:startup_namer/widgets/section_header.dart';


class SectionListView extends StatefulWidget {

  final List<ListSection> sections;

  const SectionListView({Key key, this.sections}) : super(key: key);

  @override
  SectionListViewState createState() => new SectionListViewState(sections);
}

class SectionListViewState extends State<SectionListView> {
  final List<ListSection> sections;
  final Map<String, bool> expanded = {};

  SectionListViewState(this.sections);

  @override
  Widget build(BuildContext context) {
    return new SliverList(
        delegate: new SliverChildBuilderDelegate(
          _buildRow,
          childCount: _childCount(),
        )
    );
  }


  @override
  void initState() {
    super.initState();
    sections.forEach((section) => expanded[section.title] = section.initiallyExpanded);
  }

  Widget _buildRow(BuildContext context, int index) {
    int cursor = 0;

    for (var section in sections) {
      if (cursor == index) {
        //debugPrint("Section found a cursor: " + cursor.toString() + " index: " + index.toString());
        return _buildSectionHeader(section);
      } else if (expanded[section.title]) {
        cursor++;
        // debugPrint("Expanded Section finding row at cursor: " + cursor.toString() + " index: " + index.toString());

        if (index < (cursor + section.children.length)) {
          return _buildListItem(section.children[index - cursor]);
        } else {
          cursor += section.children.length;
        }
      } else {
        cursor++;
      }
    }

    return null;
  }

  _childCount() {
    int childCount = sections.length;
    for (var section in sections) {
      if (expanded.containsKey(section.title)) {
        childCount += section.children.length;
      }
    }

    return childCount;
  }

  Widget _buildSectionHeader(ListSection section) {
    return new _SectionListItem(key: new Key(section.title),
        child: new SectionHeader(
          title: section.title,
          count: section.children.length,
          onTap: () {
            setState(() {
              expanded[section.title] = !expanded[section.title];
            });
          },
        )
    );
  }

  Widget _buildListItem(Widget widget) {
    return new _SectionListItem(
        key: widget.key,
        child: widget
    );
  }
}

class ListSection {
  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;

  ListSection({@required this.children, this.title = "", this.initiallyExpanded = false})
      : assert(children != null);
}

class _SectionListItem extends StatelessWidget {
  final Widget child;

  const _SectionListItem({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(child: child);
  }

}