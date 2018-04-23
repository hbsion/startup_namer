enum CashoutStatus {
  ENABLED,
  DISABLED,
  SUSPENDED,
  UNKNOWN
}

CashoutStatus toCashoutStatue(String value) {
  switch(value) {
    case "ENABLED":
      return CashoutStatus.ENABLED;
    case "DISABLED":
      return CashoutStatus.DISABLED;
    case "SUSPENDED":
      return CashoutStatus.SUSPENDED;
    default:
      return CashoutStatus.UNKNOWN;
  }
}