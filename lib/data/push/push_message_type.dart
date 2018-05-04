

enum PushMessageType {
  oddsUpdate,
  unknown
}

PushMessageType toPushMessageType(int type) {
  switch(type) {
    case 11:
      return PushMessageType.oddsUpdate;
    default:
      return PushMessageType.unknown;
  }
}