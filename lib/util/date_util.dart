import 'package:intl/intl.dart';

class DateUtility {
  static final _format = DateFormat("yyyy-MM-dd HH:mm");

  static String toFormattedString(DateTime date) {
    return _format.format(date);
  }

  static DateTime parseDate(String dateString) {
    return _format.parse(dateString);
  }
}
