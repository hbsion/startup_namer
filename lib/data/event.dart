import 'event_participant.dart';
import 'event_state.dart';
import 'group_path.dart';
import 'team_colors.dart';

class Event {
  final int id;
  final String name;
  final String homeName;
  final String awayName;
  final DateTime start;
  final String originalStartTime;
  final String group;
  final int groupId;
  final List<GroupPath> path;
  final int nonLiveBoCount;
  final int liveBoCount;
  final List<String> tags;
  final String sport;
  final EventState state;
  final String distance;
  final int eventNumber;
  final String nameDetails;
  final String editorial;
  final String raceClass;
  final String raceType;
  final String trackType;
  final String going;
  // timeform
  final List<EventParticipant> participants;
  final int rank;
  final int groupSortOrder;
  final TeamColors teamColors;
  final int sortOrder;
  final DateTime prematchEnd;
  final String meetingId;
  int mainBetOfferId;

  Event({this.id,
    this.name,
    this.homeName,
    this.awayName,
    this.start,
    this.originalStartTime,
    this.group,
    this.groupId,
    this.path,
    this.nonLiveBoCount,
    this.liveBoCount,
    this.tags,
    this.sport,
    this.state,
    this.distance,
    this.eventNumber,
    this.nameDetails,
    this.editorial,
    this.raceClass,
    this.raceType,
    this.trackType,
    this.going,
    this.participants,
    this.rank,
    this.groupSortOrder,
    this.teamColors,
    this.sortOrder,
    this.prematchEnd,
    this.meetingId}); //timeform


  Event.fromJson(Map<String, dynamic> json) : this (
    id: json["id"],
    name: json["name"],
    homeName: json["homeName"],
    awayName: json["awayName"],
    start: json["start"] != null ? DateTime.parse(json["start"]) : null,
    originalStartTime: json["originalStartTime"],
    group: json["group"],
    groupId: json["groupId"],
    path: ((json["path"] ?? []) as List<dynamic>).map((j) => GroupPath.fromJson(j)).toList(),
    nonLiveBoCount: json["nonLiveBoCount"],
    liveBoCount: json["liveBoCount"],
    tags: ((json["tags"] ?? []) as List<dynamic>).map<String>((o) => o.toString()).toList(),
    sport: json["sport"],
    state: toEventState(json["state"]),
    distance: json["distance"],
    eventNumber: json["eventNumber"],
    nameDetails: json["nameDetails"],
    editorial: json["editorial"],
    raceClass: json["raceClass"],
    raceType: json["raceType"],
    trackType: json["trackType"],
    going: json["going"],
    participants: ((json["participants"] ?? []) as List<dynamic>).map((j) => EventParticipant.fromJson(j)).toList(),
    rank: json["rank"],
    groupSortOrder: json["groupSortOrder"],
    teamColors: TeamColors.fromJson(json["teamColors"]),
    sortOrder: json["sortOrder"],
    prematchEnd: json["prematchEnd"] != null ? DateTime.parse(json["prematchEnd"]) : null,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Event &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              homeName == other.homeName &&
              awayName == other.awayName &&
              start == other.start &&
              originalStartTime == other.originalStartTime &&
              group == other.group &&
              groupId == other.groupId &&
              path == other.path &&
              nonLiveBoCount == other.nonLiveBoCount &&
              liveBoCount == other.liveBoCount &&
              tags == other.tags &&
              sport == other.sport &&
              state == other.state &&
              distance == other.distance &&
              eventNumber == other.eventNumber &&
              nameDetails == other.nameDetails &&
              editorial == other.editorial &&
              raceClass == other.raceClass &&
              raceType == other.raceType &&
              trackType == other.trackType &&
              going == other.going &&
              participants == other.participants &&
              rank == other.rank &&
              groupSortOrder == other.groupSortOrder &&
              teamColors == other.teamColors &&
              sortOrder == other.sortOrder &&
              prematchEnd == other.prematchEnd &&
              meetingId == other.meetingId;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      homeName.hashCode ^
      awayName.hashCode ^
      start.hashCode ^
      originalStartTime.hashCode ^
      group.hashCode ^
      groupId.hashCode ^
      path.hashCode ^
      nonLiveBoCount.hashCode ^
      liveBoCount.hashCode ^
      tags.hashCode ^
      sport.hashCode ^
      state.hashCode ^
      distance.hashCode ^
      eventNumber.hashCode ^
      nameDetails.hashCode ^
      editorial.hashCode ^
      raceClass.hashCode ^
      raceType.hashCode ^
      trackType.hashCode ^
      going.hashCode ^
      participants.hashCode ^
      rank.hashCode ^
      groupSortOrder.hashCode ^
      teamColors.hashCode ^
      sortOrder.hashCode ^
      prematchEnd.hashCode ^
      meetingId.hashCode;

  @override
  String toString() {
    return 'Event{id: $id, name: $name, homeName: $homeName, awayName: $awayName, start: $start, originalStartTime: $originalStartTime, group: $group, groupId: $groupId, path: $path, nonLiveBoCount: $nonLiveBoCount, liveBoCount: $liveBoCount, tags: $tags, sport: $sport, state: $state, distance: $distance, eventNumber: $eventNumber, nameDetails: $nameDetails, editorial: $editorial, raceClass: $raceClass, raceType: $raceType, trackType: $trackType, going: $going, participants: $participants, rank: $rank, groupSortOrder: $groupSortOrder, teamColors: $teamColors, sortOrder: $sortOrder, prematchEnd: $prematchEnd, meetingId: $meetingId}';
  }
  
}