import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:svan_play/app_theme.dart';
import 'package:svan_play/widgets/empty_widget.dart';
import 'package:svan_play/widgets/list_section.dart';
import 'package:svan_play/widgets/section_header.dart';

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
    return new ListView.builder(
      itemBuilder: _buildSection,
      itemCount: widget.sections.length,
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

  Widget _buildSection(BuildContext context, int index) {
    var section = widget.sections[index];
    return new StickyHeader(
      header: _buildSectionHeader(section),
      content: new Container(
        child: _buildSectionBody(context, section),
      ),
    );
  }

  Widget _buildSectionBody(BuildContext context, ListSection section) {
    var isExapanded = _expanded[section.title];

    if (isExapanded) {
      var dividedColor = AppTheme.of(context).list.itemDividerColor;
      List<Widget> widgets = [];
      for (var i = 0; i < section.count; ++i) {
        if (i > 0) {
          widgets.add(Divider(height: 1.0, color: dividedColor));
        }
        widgets.add(section.builder(context, i));
      }
      return Column(
        children: widgets,
      );
    }
    return new EmptyWidget();
  }

  Widget _buildSectionHeader(ListSection section) {
    return new _SectionListItem(
        key: new Key(section.title),
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

  Widget _buildListItem(BuildContext context, Widget widget) {
    return new _SectionListItem(
        key: widget.key,
        child: new Column(
          children: <Widget>[
            widget,
            Divider(height: 1.0, color: AppTheme.of(context).list.itemDividerColor),
          ],
        ));
  }
}

class _SectionListItem extends StatelessWidget {
  final Widget child;

  const _SectionListItem({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(child: child);
  }
}
