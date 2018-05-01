import 'package:date_format/date_format.dart';

DateTime date(DateTime dt) {
  return new DateTime(dt.year, dt.month, dt.day);
}

DateTime withHours(DateTime dt) {
  return new DateTime(dt.year, dt.month, dt.day, dt.hour);
}

String formatDurationTime(Duration duration) {
  var dt = new DateTime(2000, 1, 1);
  var dt2 = dt.add(duration);
  return formatDate(dt2, [nn, ":", ss]);
}

String prettyDate(DateTime dt) {
   if (isToday(dt)) {
     return "Today";
   } else if(isTomorrow(dt)) {
     return "Tomorrow";
   } else {
     return formatDate(dt, [DD, " ", d, " ", MM, " ", yyyy]);
   }
}

String hourRange(DateTime dt) {
     return formatDate(dt, [HH, ":", nn]) + " - " +
         formatDate(dt,  [HH, ":59"]);
}

bool isToday(DateTime dt) {
  var now = DateTime.now();
  return dt.year == now.year && dt.month == dt.month && now.day == dt.day;
}

bool isTomorrow(DateTime dt) {
  var tomorrow = DateTime.now().add(Duration(days: 1));
  return dt.year == tomorrow.year && dt.month == dt.month && tomorrow.day == dt.day;
}
