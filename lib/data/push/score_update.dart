import 'package:svan_play/data/score.dart';

class ScoreUpdate {
  final int eventId;
  final Score score;

  ScoreUpdate({this.eventId, this.score});

  ScoreUpdate.fromJson(Map<String, dynamic> json) : this(
      eventId: json["eventId"],
      score: new Score.fromJson(json["score"])
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ScoreUpdate &&
              runtimeType == other.runtimeType &&
              eventId == other.eventId &&
              score == other.score;

  @override
  int get hashCode =>
      eventId.hashCode ^
      score.hashCode;

  @override
  String toString() {
    return 'ScoreUpdate{eventId: $eventId, score: $score}';
  }
}

