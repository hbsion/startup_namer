enum EventState {
  NOT_STARTED,
  STARTED,
  FINISHED,
  UNKNOWN
}

EventState toEventState(String value) {
  switch (value) {
    case "NOT_STARTED":
      return EventState.NOT_STARTED;
    case "STARTED":
      return EventState.STARTED;
    case "FINISHED":
      return EventState.FINISHED;
    default:
      return EventState.UNKNOWN;
  }
}