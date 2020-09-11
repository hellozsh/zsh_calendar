import 'package:flutter/material.dart';

typedef Widget WeekdayWidgetBuilder(int weekday);

class CalendarWeekday {
  CalendarWeekday(
      this.firstDayOfWeek, // 要显示的第一个是周一，周二，周三，周四，周五，周六还是周天
      this.height,
      { this.builder }
      ): assert(firstDayOfWeek >=0 && firstDayOfWeek <= 7);

  final int firstDayOfWeek;
  final WeekdayWidgetBuilder builder;
  final double height;
}
