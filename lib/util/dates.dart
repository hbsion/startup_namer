import 'package:date_format/date_format.dart';

DateTime date(DateTime dt) {
  return new DateTime(dt.year, dt.month, dt.day);
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

bool isToday(DateTime dt) {
  var now = DateTime.now();
  return dt.year == now.year && dt.month == dt.month && now.day == dt.day;
}

bool isTomorrow(DateTime dt) {
  var tomorrow = DateTime.now().add(Duration(days: 1));
  return dt.year == tomorrow.year && dt.month == dt.month && tomorrow.day == dt.day;
}
