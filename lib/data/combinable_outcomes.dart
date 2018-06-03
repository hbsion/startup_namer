import 'package:meta/meta.dart';
import 'package:svan_play/data/outcome.dart';
import 'package:svan_play/data/outcome_combination.dart';

class CombinableOutcomes {
  final List<Outcome> playerOutcomes;
  final List<Outcome> resultOutcomes;
  final List<OutcomeCombination> outcomeCombinations;

  CombinableOutcomes({@required this.playerOutcomes, @required this.resultOutcomes, @required this.outcomeCombinations});

  factory CombinableOutcomes.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new CombinableOutcomes(
          playerOutcomes: ((json["playerOutcomes"] ?? []) as List<dynamic>).map<Outcome>((j) => Outcome.fromJson(j)).toList(),
          resultOutcomes: ((json["resultOutcomes"] ?? []) as List<dynamic>).map<Outcome>((j) => Outcome.fromJson(j)).toList(),
          outcomeCombinations: ((json["outcomeCombinations"] ?? []) as List<dynamic>).map<OutcomeCombination>((j) => OutcomeCombination.fromJson(j)).toList()
      );
    }
    return null;
  }
}
