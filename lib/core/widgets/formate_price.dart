import 'package:intl/intl.dart';

String formatPrice(num value) {
  return ((value - value.floor() < 0.5)
      ? value.floor()
      : value.floor() + 1
  ).toString();
}


String formatDateTime(dynamic date) {
  try {
    DateTime dt;

    if (date == null) return 'N/A';

    if (date is String) {
      if (date.isEmpty) return 'N/A';
      dt = DateTime.tryParse(date) ?? DateTime(1970);
    } else if (date is DateTime) {
      dt = date;
    } else {
      return 'N/A';
    }

    return DateFormat("dd MMM yyyy, hh:mm a").format(dt);
  } catch (e) {
    return 'N/A';
  }
}


