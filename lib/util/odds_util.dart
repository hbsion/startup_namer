import 'package:svan_play/data/odds.dart';
import 'package:svan_play/models/odds_format.dart';

String formatOdds(Odds odds, OddsFormat format) {
  switch (format) {
    case OddsFormat.Fractional:
      return odds.fractional ?? "-";
    case OddsFormat.American:
      return odds.american ?? "-";
    case OddsFormat.Decimal:
    default:
      if (odds.decimal == null) {
        return "-";
      }

      double decimal = odds.decimal / 1000;
      return decimal.toStringAsFixed(2);
  }
}
