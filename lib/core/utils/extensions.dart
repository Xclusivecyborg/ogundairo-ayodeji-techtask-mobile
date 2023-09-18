import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String get formattedDate {
    return DateFormat('MMM dd, yyyy').format(this);
  }
}

extension StringExtension on String? {
  DateTime get toDateTime {
    if (this == null) return DateTime.now();
    return DateTime.parse(this!);
  }
}
