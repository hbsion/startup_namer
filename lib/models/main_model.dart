import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svan_play/models/odds_format.dart';

class MainModel extends Model {
  Brightness _brightness = Brightness.light;
  OddsFormat _oddsFormat = OddsFormat.Decimal;

  MainModel() {
    SharedPreferences.getInstance().then((prefs) {
      _brightness = Brightness.values[prefs.getInt("theme") ?? 0];
      _oddsFormat = OddsFormat.values[prefs.getInt("oddsFormat") ?? 0];
      notifyListeners();
    });
  }

  Brightness get brightness => _brightness;

  OddsFormat get oddsFormat => _oddsFormat;

  void updateTheme(Brightness brightness) {
    _brightness = brightness;
    notifyListeners();
    _save();
  }

  void uppdateOddsFormat(OddsFormat oddsFormat) {
    _oddsFormat = oddsFormat;
    notifyListeners();
    _save();
  }

  void _save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("theme", _brightness.index);
    prefs.setInt("oddsFormat", _oddsFormat.index);
  }
}