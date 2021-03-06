import 'package:meta/meta.dart';
import 'package:svan_play/data/outcome_type.dart';

import 'cashout_status.dart';
import "odds.dart";
import "outcome_criterion.dart";
import 'outcome_status.dart';

class Outcome {
  final int id;
  final String label;
  final Odds odds;
  final int line;
  final String distance;
  final bool scratched;
  final int startNr;
  final List<int> prevOdds;
  final OutcomeCriterion criterion;
  final String participant;
  final bool popular;
  final OutcomeType type;
  final bool homeTeamMember;
  final int betOfferId;
  final DateTime changedDate;
  final int participantId;
  final OutcomeStatus status;
  final CashoutStatus cashoutStatus;
  final String homeScore;
  final String awayScore;
  Odds lastOdds;
  DateTime oddsChanged;

  Outcome(
      {@required this.id,
      @required this.betOfferId,
      this.label,
      this.odds,
      this.type,
      this.changedDate,
      this.status,
      this.participant,
      this.participantId,
      this.line,
      this.homeTeamMember,
      this.criterion,
      this.distance,
      this.scratched,
      this.startNr,
      this.prevOdds,
      this.popular,
      this.cashoutStatus,
      this.homeScore,
      this.awayScore});

  Outcome.fromJson(Map<String, dynamic> json)
      : this(
            id: json["id"],
            betOfferId: json["betOfferId"],
            label: json["label"],
            type: toOutcomeType(json["type"]),
            changedDate: json["changedDate"] != null ? DateTime.parse(json["changedDate"]).toLocal() : null,
            status: toOutcomeStatus(json["status"]),
            cashoutStatus: toCashoutStatue(json["cashOutStatus"]),
            odds: Odds.fromJson(json),
            participant: json["participant"],
            participantId: json["participantId"],
            line: json["line"],
            homeTeamMember: json["homeTeamMember"] ?? false,
            criterion: OutcomeCriterion.fromJson(json["criterion"]),
            distance: json["distance"],
            scratched: json["scratched"] ?? false,
            startNr: json["startNr"],
            popular: json["popular"],
            homeScore: json["homeScore"],
            awayScore: json["awayScore"],
            prevOdds: ((json["prevOdds"] ?? []) as List<dynamic>).map<int>((i) => i).toList());

  Outcome withNewOdds(Odds newOdds) {
    Outcome outcome = new Outcome(
        id: id,
        betOfferId: betOfferId,
        label: label,
        type: type,
        changedDate: changedDate,
        status: status,
        cashoutStatus: cashoutStatus,
        odds: newOdds,
        participant: participant,
        participantId: participantId,
        line: line,
        homeTeamMember: homeTeamMember,
        criterion: criterion,
        distance: distance,
        scratched: scratched,
        startNr: startNr,
        popular: popular,
        homeScore: homeScore,
        awayScore: awayScore,
        prevOdds: prevOdds);
    outcome.lastOdds = odds;
    outcome.oddsChanged = DateTime.now();

    return outcome;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Outcome &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label &&
          odds == other.odds &&
          line == other.line &&
          distance == other.distance &&
          scratched == other.scratched &&
          startNr == other.startNr &&
          prevOdds == other.prevOdds &&
          criterion == other.criterion &&
          participant == other.participant &&
          popular == other.popular &&
          type == other.type &&
          homeTeamMember == other.homeTeamMember &&
          betOfferId == other.betOfferId &&
          changedDate == other.changedDate &&
          participantId == other.participantId &&
          status == other.status &&
          homeScore == other.homeScore &&
          awayScore == other.awayScore &&
          cashoutStatus == other.cashoutStatus;

  @override
  int get hashCode =>
      id.hashCode ^
      label.hashCode ^
      odds.hashCode ^
      line.hashCode ^
      distance.hashCode ^
      scratched.hashCode ^
      startNr.hashCode ^
      prevOdds.hashCode ^
      criterion.hashCode ^
      participant.hashCode ^
      popular.hashCode ^
      type.hashCode ^
      homeTeamMember.hashCode ^
      betOfferId.hashCode ^
      changedDate.hashCode ^
      participantId.hashCode ^
      status.hashCode ^
      homeScore.hashCode ^
      awayScore.hashCode ^
      cashoutStatus.hashCode;

  @override
  String toString() {
    return 'Outcome{id: $id, label: $label, odds: $odds, line: $line, distance: $distance, scratched: $scratched, startNr: $startNr, prevOdds: $prevOdds, criterion: $criterion, participant: $participant, popular: $popular, type: $type, homeTeamMember: $homeTeamMember, betOfferId: $betOfferId, changedDate: $changedDate, participantId: $participantId, status: $status, cashoutStatus: $cashoutStatus, homeScore: $homeScore, awayScore: $awayScore, lastOdds: $lastOdds, oddsChanged: $oddsChanged}';
  }

}
