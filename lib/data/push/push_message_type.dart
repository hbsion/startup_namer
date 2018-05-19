enum PushMessageType {
  oddsUpdate,
  matchClockUpdate,
  scoreUpdate,
  eventStatsUpdate,
  betOfferStatusUpdate,
  betOfferAdded,
  betOfferRemoved,
  unknown
}

PushMessageType toPushMessageType(int type) {
  switch (type) {
    case 6:
      return PushMessageType.betOfferAdded;
    case 7:
      return PushMessageType.betOfferRemoved;
    case 8:
      return PushMessageType.betOfferStatusUpdate;
    case 11:
      return PushMessageType.oddsUpdate;
    case 15:
      return PushMessageType.matchClockUpdate;
    case 16:
      return PushMessageType.scoreUpdate;
    case 17:
      return PushMessageType.eventStatsUpdate;
    default:
      return PushMessageType.unknown;
  }
}