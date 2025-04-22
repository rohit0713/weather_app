import 'package:intl/intl.dart';

String getDayAndDateFromTimestamp(int timestamp) {
  // Convert seconds to DateTime
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  // Format day name and date
  String dayName = _weekdayName(date.weekday); 
  String dateFormatted = "${_monthName(date.month)} ${date.day}";

  return "$dateFormatted, $dayName";
}

// Helper: Weekday names
String _weekdayName(int weekday) {
  const days = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];
  return days[weekday - 1];
}

// Helper: Month names
String _monthName(int month) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  return months[month - 1];
}

String formatTimeFromTimestamp(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return DateFormat('h:mm a').format(date); // Example: 3:45 PM
}