import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';
import 'package:svan_play/widgets/section_header.dart';

class SectionListView extends StatefulWidget {
  final bool asSliver;
  final List<ListSection> sections;

  const SectionListView({Key key, this.sections, this.asSliver = true}) : super(key: key);

  @override
  _SectionListViewState createState() => new _SectionListViewState();
}

class _SectionListViewState extends State<SectionListView> {
  Map<String, bool> _expanded = {};

  @override
  Widget build(BuildContext context) {
    if (widget.asSliver) {
      return new SliverList(
          delegate: new SliverChildBuilderDelegate(
        _buildRow,
        childCount: _childCount(),
      ));
    }

    return new ListView.builder(
      itemBuilder: _buildRow,
      itemCount: _childCount(),
    );
  }

  @override
  void initState() {
    super.initState();
    _expanded = PageStorage.of(context)?.readState(context, identifier: widget.key) ?? {};

    if (_expanded.isEmpty) {
      widget.sections.forEach((section) => _expanded[section.title] = section.initiallyExpanded);
    }
  }

  void _saveState() {
    PageStorage.of(context)?.writeState(context, _expanded, identifier: widget.key);
  }

  Widget _buildRow(BuildContext context, int index) {
    int cursor = 0;

    for (var section in widget.sections) {
      if (cursor == index) {
        //debugPrint("Section found a cursor: " + cursor.toString() + " index: " + index.toString());
        return _buildSectionHeader(section);
      } else if (_expanded[section.title]) {
        cursor++;
        // debugPrint("Expanded Section finding row at cursor: " + cursor.toString() + " index: " + index.toString());

        if (index < (cursor + section.count)) {
          return _buildListItem(section.builder(context, index - cursor));
        } else {
          cursor += section.count;
        }
      } else {
        cursor++;
      }
    }

    return null;
  }

  _childCount() {
    int childCount = widget.sections.length;
    for (var section in widget.sections) {
      if (_expanded.containsKey(section.title)) {
        childCount += section.count;
      }
    }

    return childCount;
  }

  Widget _buildSectionHeader(ListSection section) {
    return new _SectionListItem(
        key: new Key(section.title),
        child: new SectionHeader(
          leading: section.leading,
          title: section.title,
          titleStyle: section.titleStyle,
          count: section.count,
          onTap: () {
            setState(() {
              _expanded[section.title] = !_expanded[section.title];
              _saveState();
            });
          },
        ));
  }

  Widget _buildListItem(Widget widget) {
    return new _SectionListItem(key: widget.key, child: widget);
  }
}

abstract class ListSection {
  Widget leading;
  TextStyle titleStyle;

  String get title;

  IndexedWidgetBuilder get builder;

  int get count;

  bool get initiallyExpanded;
}

class _SectionListItem extends StatelessWidget {
  final Widget child;

  const _SectionListItem({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(child: child);
  }
}

class SliverHybridList extends SliverFixedExtentList {
  const SliverHybridList({
    Key key,
    @required SliverChildDelegate delegate,
    @required double itemExtent,
  }) : super(key: key, delegate: delegate, itemExtent: itemExtent);

  @override
  void updateRenderObject(BuildContext context, RenderSliverFixedExtentList renderObject) {
    renderObject.itemExtent = 126.0;
  }
}
