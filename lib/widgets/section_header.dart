import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback onTap;

  const SectionHeader({Key key, this.title, this.count, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
        color: Colors.white,
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
                            new Expanded(child: new Text(title, style: Theme.of(context).textTheme.subhead)),
                            new Text(count.toString())
                          ],
                        )
                    ),
                    new Divider(color: Color.fromARGB(255, 0xd1, 0xd1, 0xd1), height: 2.0)
                  ],
                )
            )
        )
    );
  }
}