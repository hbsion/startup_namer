import 'package:flutter/material.dart';
import 'package:svan_play/util/banners.dart';
import 'package:svan_play/views/search/search_view.dart';

class AppToolbar extends StatelessWidget {
  final String title;
  final String sport;
  final VoidCallback onNavPress;

  const AppToolbar({Key key, this.title, this.onNavPress, this.sport}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SliverAppBar(
        expandedHeight: 56.0,
        pinned: false,
        floating: true,
        snap: false,
        title: new Text(title),
        actions: <Widget>[new IconButton(icon: const Icon(Icons.search), onPressed: _search(context))],
        leading: onNavPress != null ? new IconButton(icon: new Icon(Icons.dehaze), onPressed: onNavPress) : null,
        flexibleSpace: bannerFor(sport));
  }

  VoidCallback _search(BuildContext context) {
    return () async {
      Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new SearchView()));
    };
  }
}
