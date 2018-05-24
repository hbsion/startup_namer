import 'package:flutter/material.dart';
import 'package:svan_play/widgets/list_section.dart';
import 'package:svan_play/widgets/section_header.dart';
import 'package:svan_play/widgets/sticky/sticky_header_list.dart';

class StickySectionListView extends StatefulWidget {
  final List<ListSection> sections;

  const StickySectionListView({Key key, this.sections}) : super(key: key);

  @override
  _SectionListViewState createState() => new _SectionListViewState();
}

class _SectionListViewState extends State<StickySectionListView> {
  Map<String, bool> _expanded = {};

  @override
  Widget build(BuildContext context) {
    return new StickyList.builder(
      builder: _buildRow,
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

  StickyListRow _buildRow(BuildContext context, int index) {
    int cursor = 0;

    for (var section in widget.sections) {
      if (cursor == index) {
        return _buildSectionHeader(section);
      } else if (_expanded[section.title]) {
        cursor++;

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

  HeaderRow _buildSectionHeader(ListSection section) {
    return new HeaderRow(
        height: 44.0,
        child: new SectionHeader(
          leading: section.leading,
          trailing: section.trailing,
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

  RegularRow _buildListItem(Widget widget) {
    return new RegularRow(child: widget);
  }
}
