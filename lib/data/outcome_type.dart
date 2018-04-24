enum OutcomeType {
  ONE,
  CROSS,
  TWO,
  OVER,
  UNDER,
  YES,
  NO,
  ONE_OR_CROSS,
  ONE_OR_TWO,
  CROSS_OR_TWO,
  ONE_ONE,
  ONE_CROSS,
  ONE_TWO,
  CROSS_ONE,
  CROSS_CROSS,
  CROSS_TWO,
  TWO_ONE,
  TWO_CROSS,
  TWO_TWO,
  EVEN,
  ODD,
  WC_HOME,
  WC_AWAY,
  WC_DRAW,
  UNTYPED,
  UNKNOWN
}

OutcomeType toOutcomeType(String value) {
  switch (value) {
    case "OT_CROSS":
      return OutcomeType.CROSS;
    case "OT_ONE":
      return OutcomeType.ONE;
    case "OT_TWO":
      return OutcomeType.TWO;
    case "OT_OVER":
      return OutcomeType.OVER;
    case "OT_UNDER":
      return OutcomeType.UNDER;
    case "OT_YES":
      return OutcomeType.YES;
    case "OT_NO":
      return OutcomeType.NO;
    case "OT_ONE_OR_CROSS":
      return OutcomeType.ONE_OR_CROSS;
    case "OT_ONE_OR_TWO":
      return OutcomeType.ONE_OR_TWO;
    case "OT_CROSS_OR_TWO":
      return OutcomeType.CROSS_OR_TWO;
    case "OT_ONE_ONE":
      return OutcomeType.ONE_ONE;
    case "OT_ONE_CROSS":
      return OutcomeType.ONE_CROSS;
    case "OT_ONE_TWO":
      return OutcomeType.ONE_TWO;
    case "OT_CROSS_ONE":
      return OutcomeType.CROSS_ONE;
    case "OT_CROSS_CROSS":
      return OutcomeType.CROSS_CROSS;
    case "OT_CROSS_TWO":
      return OutcomeType.CROSS_TWO;
    case "OT_TWO_ONE":
      return OutcomeType.TWO_ONE;
    case "OT_TWO_CROSS":
      return OutcomeType.TWO_CROSS;
    case "OT_TWO_TWO":
      return OutcomeType.TWO_TWO;
    case "OT_EVEN":
      return OutcomeType.EVEN;
    case "OT_ODD":
      return OutcomeType.ODD;
    case "OT_WC_HOME":
      return OutcomeType.WC_HOME;
    case "OT_WC_AWAY":
      return OutcomeType.WC_AWAY;
    case "OT_WC_DRAW":
      return OutcomeType.WC_DRAW;
    case "OT_UNTYPED":
      return OutcomeType.UNTYPED;
  }
  return OutcomeType.UNKNOWN;
}