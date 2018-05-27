import 'package:flutter/widgets.dart';

final Image _football = new Image.asset('assets/football-banner.jpg',
    fit: BoxFit.cover, colorBlendMode: BlendMode.srcOver, color: new Color.fromARGB(90, 20, 10, 40));

final Image _iceHockey = new Image.asset('assets/icehockey-banner.jpg',
    fit: BoxFit.cover, colorBlendMode: BlendMode.srcOver, color: new Color.fromARGB(120, 20, 10, 40));

final Image _tennis = new Image.asset('assets/tennis-banner.png',
    fit: BoxFit.cover, colorBlendMode: BlendMode.srcOver, color: new Color.fromARGB(120, 20, 10, 40));

final Image _volleyball = new Image.asset('assets/volleyball-banner.jpg',
    fit: BoxFit.cover, colorBlendMode: BlendMode.srcOver, color: new Color.fromARGB(120, 20, 10, 40));

final Image _handball = new Image.asset('assets/handball-banner.jpg',
    fit: BoxFit.cover, colorBlendMode: BlendMode.srcOver, color: new Color.fromARGB(120, 20, 10, 40));

final Image _golf = new Image.asset('assets/golf-banner.jpg',
    fit: BoxFit.cover, colorBlendMode: BlendMode.srcOver, color: new Color.fromARGB(120, 20, 10, 40));

final Image _cricket = new Image.asset('assets/cricket-banner.png',
    fit: BoxFit.cover, colorBlendMode: BlendMode.srcOver, color: new Color.fromARGB(120, 20, 10, 40));

final Image _baseball = new Image.asset('assets/baseball-banner.jpg',
    fit: BoxFit.cover, colorBlendMode: BlendMode.srcOver, color: new Color.fromARGB(120, 20, 10, 40));

final Image _americanFootball = new Image.asset('assets/american-football-banner.jpg',
    fit: BoxFit.cover, colorBlendMode: BlendMode.srcOver, color: new Color.fromARGB(120, 20, 10, 40));

final Image _formulaOne = new Image.asset('assets/formula1-banner.png',
    fit: BoxFit.cover, colorBlendMode: BlendMode.srcOver, color: new Color.fromARGB(120, 20, 10, 40));

final Image _snooker = new Image.asset('assets/snooker-banner.jpg',
    fit: BoxFit.cover, colorBlendMode: BlendMode.srcOver, color: new Color.fromARGB(120, 20, 10, 40));

final Image _basketball = new Image.asset('assets/basketball-banner.jpg', fit: BoxFit.cover);

const String _defaultFallbackName = "assets/banner_1.jpg";
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
    case "basketball":
      return _basketball;
    case "golf":
      return _golf;
    case "cricket":
      return _cricket;
    case "handball":
         return _handball;
    case "baseball":
         return _baseball;
    case "american_football":
         return _americanFootball;
    case "motorsports":
         return _formulaOne;
    case "snooker":
         return _snooker;
    default:
      if (fallbackAsset == _defaultFallbackName) {
        return _defaultFallback;
      }
      return new Image.asset(fallbackAsset, fit: BoxFit.cover);
  }
}
