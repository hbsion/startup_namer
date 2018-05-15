import 'package:flutter/material.dart';
import 'package:startup_namer/app_theme.dart';

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