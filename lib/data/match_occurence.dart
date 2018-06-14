class MatchOccurence {
  final int id;
  final int eventId;
  final String occurrenceTypeId; // "CARDS_YELLOW_AWAY",
  final int secondInPeriod;
  final int secondInMatch;
  final String periodId; // "SECOND_HALF",
  final String action; // "ADDED", DELETED, MODIFIED
  final int periodIndex;

  MatchOccurence(
      {this.id,
      this.eventId,
      this.occurrenceTypeId,
      this.secondInPeriod,
      this.secondInMatch,
      this.periodId,
      this.action,
      this.periodIndex});

  MatchOccurence.fromJson(Map<String, dynamic> json)
      : this(
          id: json["id"],
          eventId: json["eventId"],
          occurrenceTypeId: json["occurrenceTypeId"],
          secondInMatch: json["secondInMatch"],
          secondInPeriod: json["secondInPeriod"],
          periodId: json["periodId"],
          action: json["action"],
          periodIndex: json["periodIndex"],
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchOccurence &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          eventId == other.eventId &&
          occurrenceTypeId == other.occurrenceTypeId &&
          secondInPeriod == other.secondInPeriod &&
          secondInMatch == other.secondInMatch &&
          periodId == other.periodId &&
          action == other.action &&
          periodIndex == other.periodIndex;

  @override
  int get hashCode =>
      id.hashCode ^
      eventId.hashCode ^
      occurrenceTypeId.hashCode ^
      secondInPeriod.hashCode ^
      secondInMatch.hashCode ^
      periodId.hashCode ^
      action.hashCode ^
      periodIndex.hashCode;

  @override
  String toString() {
    return 'Occurence{id: $id, eventId: $eventId, occurrenceTypeId: $occurrenceTypeId, secondInPeriod: $secondInPeriod, secondInMatch: $secondInMatch, periodId: $periodId, action: $action, periodIndex: $periodIndex}';
  }
}
