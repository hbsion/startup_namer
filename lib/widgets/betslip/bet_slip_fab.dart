import 'package:flutter/material.dart';
import 'package:svan_play/app_theme.dart';

class BetSlipFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: brandColorDark,
      foregroundColor: Colors.white,
      onPressed: () {},
      child: Icon(Icons.event),
    );
  }

}