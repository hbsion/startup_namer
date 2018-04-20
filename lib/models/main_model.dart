import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:startup_namer/models/odds_format.dart';

class MainModel extends Model {
  Brightness _brightness = Brightness.dark;
  OddsFormat _oddsFormat = OddsFormat.Decimal;


  Brightness get brightness => _brightness;

  OddsFormat get oddsFormat => _oddsFormat;

  void updateTheme(Brightness brightness) {
    _brightness = brightness;
    notifyListeners();
  }

  void uppdateOddsFormat(OddsFormat oddsFormat) {
    _oddsFormat = oddsFormat;
    notifyListeners();
  }
}