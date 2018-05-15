bool showMatchClockForSport(String sport) {
  switch (sport?.toLowerCase()) {
    case "tennis":
    case "volleyball":
      return false;
    default:
      return true;
  }
}
