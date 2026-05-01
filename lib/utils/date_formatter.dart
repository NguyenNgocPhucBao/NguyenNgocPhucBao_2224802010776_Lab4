import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDay(DateTime dt) => DateFormat('EEEE, d MMM').format(dt);
  static String formatHour(DateTime dt) => DateFormat('HH:mm').format(dt);
  static String formatShortDay(DateTime dt) => DateFormat('EEE, d/M').format(dt);
  static String formatFull(DateTime dt) => DateFormat('EEEE, d MMMM yyyy').format(dt);
}