import 'dart:math';

import 'package:flutter/material.dart';
import 'package:svan_play/data/shirt_colors.dart';
import 'package:color/color.dart' as ColorEx;

class TeamColorsPainter extends CustomPainter {
  final ShirtColors colors;

  TeamColorsPainter(this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = new Paint();
    paint.style = PaintingStyle.fill;

    paint.color = colors != null && colors.shirtColor1 != null ? hexColor(colors.shirtColor1) : Colors.white;
//    paint.strokeWidth = stack.width;
    var radius = size.width / 2;
    var offset = new Offset(radius, size.height / 2);
    canvas.drawCircle(offset, radius, paint);

    paint.color = colors != null && colors.shirtColor2 != null ? hexColor(colors.shirtColor2) : Colors.white;

    //    paint.strokeWidth = stack.width;
    canvas.drawArc(
      new Rect.fromCircle(
        center: offset,
        radius: radius,
      ),
      degToRad(-60),
      degToRad(180),
      true,
      paint,
    );

    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.0;
    paint.color = Colors.grey;
    canvas.drawCircle(offset, radius, paint);
  }

  Color hexColor(String hex) {
    var hexColor = new ColorEx.HexColor(hex);

    return new Color.fromARGB(255, hexColor.r, hexColor.g, hexColor.b);
  }

  static num degToRad(num deg) => deg * (pi / 180.0);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
