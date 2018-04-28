import 'package:flutter/material.dart';
import 'package:startup_namer/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final TextStyle titleStyle;
  final int count;
  final VoidCallback onTap;

  const SectionHeader({Key key, this.title, this.count, this.onTap, this.titleStyle}) : super(key: key);

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
                    new Container(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: <Widget>[
                            new Expanded(child: new Text(title, style: titleStyle != null ? Theme.of(context).textTheme.subhead.merge(titleStyle) : Theme.of(context).textTheme.subhead)),
                            new Text(count.toString())
                          ],
                        )
                    ),
                    new Divider(color: appTheme.list.headerDivider, height: 2.0)
                  ],
                )
            )
        )
    );
  }
}