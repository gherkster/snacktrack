import "package:intl/intl.dart";
import "package:dart_date/dart_date.dart";

String createDateLabel(DateTime dateTime) {
  if (dateTime.isToday) {
    return "Today";
  } else if (dateTime.isYesterday) {
    return "Yesterday";
  }
  return DateFormat.MMMd().format(dateTime);
}
