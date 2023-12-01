import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Converter {
  static String contactDateToText(BuildContext context, DateTime dateTime) {
    return DateFormat.yMMMd(
      Localizations.localeOf(context).languageCode,
    ).format(dateTime);
  }

  static String messageDateToText(BuildContext context, DateTime dateTime) {
    return '${DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(dateTime)},' +
        ' ${DateFormat.Hm(Localizations.localeOf(context).languageCode).format(dateTime)}';
  }
}
