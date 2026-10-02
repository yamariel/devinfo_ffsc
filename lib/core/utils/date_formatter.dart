import 'package:intl/intl.dart';

class DateFormatter {
  static String FormatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String FormatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  static String FormatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }
}