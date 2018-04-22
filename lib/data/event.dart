import 'participant.dart';
import 'path.dart';
import 'stream.dart';
import 'team_colors.dart';

class Event {
  final int id;
  final String name;
  final String homeName;
  final String awayName;
  final DateTime start;
  final String group;
  final String type;
  final int nonLiveBoCount;
  final bool liveBetOffers;
  final bool openForLiveBetting;
  final String boUri;
  final int groupId;
  final bool hideStartNo;
  final String sport;
  final Path path;
  final int liveBoCount;
  final String state;
  final String displayType;
  final bool hasPrematchStatistics;
  final TeamColors teamColors;
  final bool streamed;
  final List<Stream> streams;
  final List<Participant> participants;
  final String distance;
  final int eventNumber;
  final String editorial;
  final String originalStartTime;
  final String raceType;
  final String trackType;
  final String raceClass;
  final String going;

  Event({
    this.id,
    this.name,
    this.homeName,
    this.awayName,
    this.start,
    this.group,
    this.type,
    this.nonLiveBoCount,
    this.liveBetOffers,
    this.openForLiveBetting,
    this.boUri,
    this.groupId,
    this.hideStartNo,
    this.sport,
    this.path,
    this.liveBoCount,
    this.state,
    this.displayType,
    this.hasPrematchStatistics,
    this.teamColors,
    this.streamed,
    this.streams,
    this.participants,
    this.distance,
    this.eventNumber,
    this.editorial,
    this.originalStartTime,
    this.raceType,
    this.trackType,
    this.raceClass,
    this.going
  });

  Event.fromJson(Map<String, dynamic> json) : this (
    id: json["id"],
    name: json["name"],
    homeName: json["homeName"],
    awayName: json["awayName"],
    start: json["start"] != null ? DateTime.parse(json["start"]) : null,
    group: json["group"],
    type: json["type"],
    nonLiveBoCount: json["nonLiveBoCount"],
    liveBetOffers: json["liveBetOffers"] ?? false,
    openForLiveBetting: json["openForLiveBetting"] ?? false,
    boUri: json["boUri"],
    groupId: json["groupId"],
    hideStartNo: json["hideStartNo"] ?? false,
    sport: json["sport"],

  );



}