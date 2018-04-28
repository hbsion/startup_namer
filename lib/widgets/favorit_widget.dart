import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class FavoriteWidget extends StatelessWidget {
  final int eventId;

  const FavoriteWidget({Key key, @required this.eventId}) : assert(eventId != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return new IconButton(icon: new Icon(Icons.star_border), onPressed: () {});
  }
}
