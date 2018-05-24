import 'package:flutter/material.dart';
import 'package:svan_play/app_theme.dart';
import 'package:svan_play/widgets/empty_widget.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final TextStyle titleStyle;
  final int count;
  final VoidCallback onTap;
  final Widget leading;
  final Widget trailing;

  const SectionHeader({Key key, this.title, this.count, this.onTap, this.titleStyle, this.leading, this.trailing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appTheme = AppTheme.of(context);
    return new Container(
        color: appTheme.list.headerBackground,
        child: new Material(
            color: Colors.transparent,
            child: new InkWell(
                onTap: this.onTap,
                child: new Column(
                  children: <Widget>[
                    new Divider(color: appTheme.list.headerDivider, height: 2.0),
                    new Container(
                        height: 40.0,
                        padding: new EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Row(
                          children: <Widget>[
                            leading ?? new EmptyWidget(),
                            new Expanded(
                                child: new Text(title,
                                    style: titleStyle != null
                                        ? Theme.of(context).textTheme.subhead.merge(titleStyle)
                                        : Theme.of(context).textTheme.subhead)),
                            trailing ?? new Text(count.toString())
                          ],
                        )),
                    new Divider(color: appTheme.list.headerDivider, height: 2.0)
                  ],
                ))));
  }
}
