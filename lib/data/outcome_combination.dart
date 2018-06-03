import 'package:meta/meta.dart';
import 'package:svan_play/data/odds.dart';
import 'package:svan_play/data/outcome.dart';

class OutcomeCombination {
  final Odds odds;
  final Outcome playerOutcome;
  final Outcome resultOutcome;

  OutcomeCombination({@required this.odds, @required this.playerOutcome, @required this.resultOutcome});

  OutcomeCombination.fromJson(Map<String, dynamic> json)
      : this(
            odds: Odds.fromJson(json),
            playerOutcome: new Outcome.fromJson(json["resultOutcome"]),
            resultOutcome: new Outcome.fromJson(json["resultOutcome"]));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OutcomeCombination &&
          runtimeType == other.runtimeType &&
          odds == other.odds &&
          playerOutcome == other.playerOutcome &&
          resultOutcome == other.resultOutcome;

  @override
  int get hashCode => odds.hashCode ^ playerOutcome.hashCode ^ resultOutcome.hashCode;
}
