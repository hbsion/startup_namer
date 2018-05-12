import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformCircularProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return new CupertinoActivityIndicator();
    } else {
      return new CircularProgressIndicator();
    }
  }
}
