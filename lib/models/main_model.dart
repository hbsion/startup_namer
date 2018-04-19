import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model {
  Brightness _brightness = Brightness.dark;


  Brightness get brightness => _brightness;

  void updateTheme(Brightness brightness) {
    _brightness = brightness;
    notifyListeners();
  }

}