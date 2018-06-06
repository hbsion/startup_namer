import 'package:flutter/material.dart';
import 'package:svan_play/app_theme.dart';
import 'package:svan_play/widgets/empty_widget.dart';
import 'package:svan_play/widgets/expand_icon_x.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final TextStyle titleStyle;
  final int count;
  final VoidCallback onTap;
  final Widget leading;
  final Widget trailing;
  final bool isExpanded;

  const SectionHeader(
      {Key key, this.title, this.count, this.onTap, this.titleStyle, this.leading, this.trailing, this.isExpanded})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appTheme = AppTheme.of(context);
    var textStyle =
        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: appTheme.list.headerForeground).merge(titleStyle);
    return new Container(
        color: appTheme.list.headerBackground,
        child: new Material(
            color: Colors.transparent,
            child: new InkWell(
                onTap: this.onTap,
                child: new Column(
                  children: <Widget>[
                    new Container(
                        height: 40.0,
                        padding: new EdgeInsets.only(left: 16.0, right: 0.0),
                        child: Row(
                          children: <Widget>[
                            leading ?? new EmptyWidget(),
                            new Expanded(child: new Text(title, style: textStyle)),
                            trailing ?? new Text(count.toString(), style: textStyle),
                            new ExpandIconX(isExpanded: isExpanded,
                                color: AppTheme.of(context).list.headerForeground,
                                onPressed: (isExpanded) => onTap())
                          ],
                        )),
                    new Divider(color: appTheme.list.headerDivider, height: 2.0)
                  ],
                ))));
  }
}
