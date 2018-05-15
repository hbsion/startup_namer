import 'package:flutter/widgets.dart';

final Image _football = new Image.asset('assets/football-banner.jpg',
    fit: BoxFit.cover,
    colorBlendMode: BlendMode.srcOver,
    color: new Color.fromARGB(90, 20, 10, 40));

final Image _iceHockey = new Image.asset('assets/icehockey-banner.jpg',
    fit: BoxFit.cover,
    colorBlendMode: BlendMode.srcOver,
    color: new Color.fromARGB(120, 20, 10, 40));

final Image _tennis = new Image.asset('assets/tennis-banner.png',
    fit: BoxFit.cover,
    colorBlendMode: BlendMode.srcOver,
    color: new Color.fromARGB(120, 20, 10, 40));

final Image _volleyball = new Image.asset('assets/volleyball-banner.jpg',
    fit: BoxFit.cover,
    colorBlendMode: BlendMode.srcOver,
    color: new Color.fromARGB(120, 20, 10, 40));

const String  _defaultFallbackName = "assets/banner_1.jpg";
final Image _defaultFallback = new Image.asset(_defaultFallbackName, fit: BoxFit.cover);

Widget bannerFor(String sport, {String fallbackAsset = _defaultFallbackName}) {
  switch (sport?.toLowerCase()) {
    case "football":
      return _football;
    case "tennis":
      return _tennis;
    case "ice_hockey":
      return _iceHockey;
    case "volleyball":
      return _volleyball;
    default:
      if (fallbackAsset == _defaultFallbackName) {
        return _defaultFallback;
      }
      return new Image.asset(fallbackAsset, fit: BoxFit.cover);
  }
}