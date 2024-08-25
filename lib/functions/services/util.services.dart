import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class Utility {
  static String formatTimestamp(String timestamp) {
    try {
      // Parse the ISO 8601 timestamp
      DateTime dateTime = DateTime.parse(timestamp);

      // Format the date and time
      return DateFormat.yMMMd().add_jm().format(dateTime);
    } catch (e) {
      // Handle any parsing errors
      print('Error parsing timestamp: $e');
      return 'Invalid date';
    }
  }

  static String getRelativeTime(String timestamp) {
    try {
      // Parse the ISO 8601 timestamp
      DateTime dateTime = DateTime.parse(timestamp);

      // Get the current time
      // ignore: unused_local_variable
      DateTime now = DateTime.now();

      // Use the timeago package to get the relative time
      return timeago.format(dateTime, locale: 'en_short');
    } catch (e) {
      // Handle any parsing errors
      print('Error parsing timestamp: $e');
      return 'Invalid date';
    }
  }
}
