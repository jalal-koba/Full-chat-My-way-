import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String dateFormatted(time) {
  DateFormat formatter = DateFormat(
    'yyyy-MM-dd hh:mm a',
  );

  if (time is String) {
    DateTime dateTime = DateTime.parse(time);
    return formatter.format(dateTime.toLocal());
  }

  return formatter.format(time.toLocal());
}

String dateBubbleFormat(DateTime date) {
  String formatDate = DateFormat(
    'd MMMM',
  ).format(date.toLocal());

  return formatDate;
}

String dateFormattedMessage(DateTime time) {
  String formatDate = DateFormat(
    'h:mm a',
  ).format(time.toLocal());

  return formatDate;
}

bool comparTowDates(DateTime date1, DateTime date2) {
  return (date1.day != date2.day && date1.month == date2.month) ||
      (date1.day == date2.day && date1.month != date2.month);
}

bubbleTween(AnimationController controller) => TweenSequence<Color?>(
      [
        TweenSequenceItem(
          tween: ColorTween(
            begin: Colors.transparent,
            end: const Color(0XFFF1F8E8),
          ),
          weight: 1.0,
        ),
        TweenSequenceItem(
          tween: ColorTween(
            begin: const Color(0XFFF1F8E8),
            end: const Color(0XFFD8EFD3),
          ),
          weight: 3.0,
        ),
        TweenSequenceItem(
          tween: ColorTween(
            begin: const Color(0XFFD8EFD3),
            end: Colors.transparent,
          ),
          weight: 1.0,
        ),
      ],
    ).animate(controller);
