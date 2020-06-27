import 'package:intl/intl.dart';

class _DateFormat {
  static final ymdDateFormat = DateFormat('yyyy/MM/dd');
}

DateFormat getDateFormat() => _DateFormat.ymdDateFormat;

String formatDateRange(from, to) =>
    '${_DateFormat.ymdDateFormat.format(from)} - ${to == null ? "Now" : _DateFormat.ymdDateFormat.format(to)}';
