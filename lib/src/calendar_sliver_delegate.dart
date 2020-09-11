

import 'package:flutter/material.dart';
import 'calendar_util.dart';
import 'dart:math' as math;
import 'calendar_carousel.dart';
import 'calendar_weekday.dart';


class CalendarSliverDelegate extends SliverPersistentHeaderDelegate {

  final DateTime startTime;  // 启始日期
  final DateTime endTime;  // 结束日期
  final DateTime currentPageTime;  // 当前要显示的日期, 默认当前时间

  final CurrentPageDate currentPageDate;

  final CalendarWeekday weekdayHeader;
  final DayWidgetBuilder dayWidgetBuilder;
  final double childAspectRatio;

  final CalendarController calendarController;

  CalendarSliverDelegate({

    @required this.startTime,
    @required this.endTime,
    @required this.weekdayHeader,

    this.currentPageDate,
    this.dayWidgetBuilder,
    this.childAspectRatio = 1,
    this.calendarController,

    currentPageTime,

  }) :  assert(startTime != null),
        assert(endTime != null),
        assert(weekdayHeader != null),
        this.currentPageTime = currentPageTime ?? DateTime.now(),
        assert(!(currentPageTime.isBefore(startTime))),
        assert(!(endTime.isBefore(startTime))),
        assert(!(endTime.isBefore(currentPageTime)));



  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {

    if(shrinkOffset > maxExtent - minExtent) {
      shrinkOffset = maxExtent - minExtent;
    }


    return  CalendarCarousel(

      shrinkageHeight: shrinkOffset,
      startTime: startTime,
      endTime: endTime,
      currentPageTime: currentPageTime,
      calendarShow: CalendarShow.CalendarShowMonth,
      weekdayHeader: weekdayHeader,
      dayWidgetBuilder:dayWidgetBuilder,
      calendarController: calendarController,
      currentPageDate: currentPageDate,
      childAspectRatio: childAspectRatio,
    );
  }


  @override
  double get maxExtent{


    double max = calendarController.getMaxHeight(childAspectRatio,weekdayHeader.firstDayOfWeek, currentPageTime);
    if(max <= 0) {
      return 300;
    }
    return max + weekdayHeader.height;
  }

  @override
  double get minExtent {

     double min = calendarController.getMinHeight(childAspectRatio,weekdayHeader.firstDayOfWeek, currentPageTime);
    return min + weekdayHeader.height;
  }

  @override
  bool shouldRebuild(CalendarSliverDelegate oldDelegate) {

    return maxExtent != oldDelegate.maxExtent ||
        minExtent != oldDelegate.minExtent ||
        currentPageTime != oldDelegate.currentPageTime;
  }

}

















