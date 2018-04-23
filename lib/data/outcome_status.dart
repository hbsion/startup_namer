enum OutcomeStatus {
  OPEN,
  CLOSED,
  SUSPENDED,
  SETTLED,
  UNKNOWN
}

OutcomeStatus toOutcomeStatus(String value) {
  switch(value) {
    case "OPEN":
      return OutcomeStatus.OPEN;
    case "CLOSED":
      return OutcomeStatus.CLOSED;
    case "SETTLED":
      return OutcomeStatus.SETTLED;
    default:
      return OutcomeStatus.UNKNOWN;
  }
}