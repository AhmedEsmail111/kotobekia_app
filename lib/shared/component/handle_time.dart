import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';

String getTimeDifference(DateTime timestamp, AppLocalizations locale) {
  DateTime currentTime = DateTime.now();
  Duration difference = currentTime.difference(timestamp).abs();

  if (difference.inSeconds < 60) {
    return locale.now;
  } else if (difference.inMinutes < 60) {
    String minutesText = locale.minutes;
    String agoText = locale.ago;
    return '${difference.inMinutes} $minutesText $agoText';
  } else if (difference.inHours < 24) {
    String hoursText = locale.hours;
    String agoText = locale.ago;
    return '${difference.inHours} $hoursText $agoText';
  } else if (difference.inDays < 7) {
    String daysText = locale.days;
    String agoText = locale.ago;

    return '${difference.inDays} $daysText $agoText';
  } else if (difference.inDays < 30) {
    int weeks = (difference.inDays / 7).floor();
    String weeksText = locale.weeks;
    String agoText = locale.ago;

    return '$weeks $weeksText $agoText';
  } else if (difference.inDays < 365) {
    int months = (difference.inDays / 30).floor();
    String monthsText = locale.months;
    String agoText = locale.ago;

    return '$months $monthsText $agoText';
  } else {
    int years = (difference.inDays / 365).floor();
    String yearsText = locale.years;
    String agoText = locale.ago;

    return '$years $yearsText $agoText';
  }
}

