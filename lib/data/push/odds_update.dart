import 'package:startup_namer/data/push/outcome_update.dart';

class OddsUpdate {
  final int eventId;
  final List<OutcomeUpdate> outcomes;

  OddsUpdate({this.eventId, this.outcomes});

  OddsUpdate.fromJson(Map<String, dynamic> json) : this(
    eventId: json["eventId"],
    outcomes: ((json["outcomes"] ?? []) as List<dynamic>).map<OutcomeUpdate>((j) => OutcomeUpdate.fromJson(j)).toList());
}

