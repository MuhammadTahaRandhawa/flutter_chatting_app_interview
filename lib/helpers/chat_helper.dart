import 'package:intl/intl.dart';

class ChatHelpers {
  ChatHelpers._();

  static String convertChatDateTimeToString(DateTime dateTime) {
    final DateTime now = DateTime.now();

    // Check if the given DateTime is today
    bool isToday = dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;

    if (isToday) {
      // Format time in 12-hour format
      final DateFormat timeFormatter = DateFormat('hh:mm a');
      return timeFormatter.format(dateTime);
    } else {
      // Format date in dd/MM/yyyy format
      final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
      return dateFormatter.format(dateTime);
    }
  }
}
