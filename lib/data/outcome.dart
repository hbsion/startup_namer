import 'package:meta/meta.dart';

import "outcome_criterion.dart";
import "odds.dart";

class Outcome {
  final int id;
  final int betOfferId;
  final String label;
  final Odds odds;
  final String type;
  final DateTime changedDate;
  final String status;
  final String participant;
  final int participantId;
  final int line;
  final bool homeTeamMember;
  final OutcomeCriterion criterion;

  Outcome({
    @required this.id,
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
    this.criterion
  });

  Outcome.fromJson(Map<String, dynamic> json) : this(
    id: json["id"],
    betOfferId: json["betOfferId"],
    label: json["label"],
    type: json["type"],
    odds: Odds.fromJson(json),
    criterion: OutcomeCriterion.fromJson(json["criterion"]),
    status: json["status"],
    participant: json["participant"],
    participantId: json["participantId"],
    line: json["line"],
    homeTeamMember: json["homeTeamMember"] ?? false,
    changedDate: json["changedDate"] != null ? DateTime.parse(json["changedDate"]) : null,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Outcome &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              betOfferId == other.betOfferId &&
              label == other.label &&
              odds == other.odds &&
              type == other.type &&
              changedDate == other.changedDate &&
              status == other.status &&
              participant == other.participant &&
              participantId == other.participantId &&
              line == other.line &&
              homeTeamMember == other.homeTeamMember &&
              criterion == other.criterion;

  @override
  int get hashCode =>
      id.hashCode ^
      betOfferId.hashCode ^
      label.hashCode ^
      odds.hashCode ^
      type.hashCode ^
      changedDate.hashCode ^
      status.hashCode ^
      participant.hashCode ^
      participantId.hashCode ^
      line.hashCode ^
      homeTeamMember.hashCode ^
      criterion.hashCode;

  @override
  String toString() {
    return 'Outcome{id: $id, betOfferId: $betOfferId, label: $label, odds: $odds, type: $type, changedDate: $changedDate, status: $status, participant: $participant, participantId: $participantId, line: $line, homeTeamMember: $homeTeamMember, criterion: $criterion}';
  }


}