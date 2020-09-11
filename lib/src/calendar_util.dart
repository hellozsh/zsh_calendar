


import 'package:flutter/cupertino.dart';

const _IntegerHalfMax = 0x7fffffff ~/ 2;
const _kInitIndex = _IntegerHalfMax;

enum CalendarShow {

  CalendarShowMonth,

  CalendarShowWeek,
}

class CalendarUtil {

  final DateTime initTime;  // 当前要显示的日期, 默认当前时间
  final int firstDayOfWeek;
  final double childAspectRatio;
  CalendarShow calendarShow;

  CalendarUtil({
    @required this.initTime,
    @required this.firstDayOfWeek,
    @required this.childAspectRatio,
    this.calendarShow,
  }):assert(initTime != null),
        assert(firstDayOfWeek != null),
          assert(childAspectRatio != null);


  int initIndex() {

    return _kInitIndex;
  }


  // 计算日期对应的索引
   int indexOf(DateTime dateTime) {

     if(calendarShow == CalendarShow.CalendarShowMonth) {
       return  _monthIndex(dateTime);
     } else {
       return _weekIndex(dateTime);
     }
  }


  // 给一个区间，如果选中日期在这个区间，那么不需要更改选中日期
  DateTime getActualDate(int index, DateTime currentTime) {


    if (calendarShow == CalendarShow.CalendarShowMonth) {

      int month = (_kInitIndex - index);

      DateTime minDateTime = DateTime(this.initTime.year, this.initTime.month -month);
      DateTime maxDateTime = DateTime(this.initTime.year, this.initTime.month -month + 1);

      if(!currentTime.isBefore(minDateTime) && currentTime.isBefore(maxDateTime)) {

         return currentTime;
       }
       return minDateTime;

    } else {

      DateTime weekDate = this.initTime.add(Duration(days: 7 * (index - _kInitIndex)));

      var day = -((this.initTime.weekday - (this.firstDayOfWeek % 7)) % 7);

      var minWeekDate = weekDate.add(Duration(days: day));
      var maxWeekDate = minWeekDate.add(Duration(days: 7));

      if(!currentTime.isBefore(minWeekDate) && currentTime.isBefore(maxWeekDate)) {
        return currentTime;
      }
      return minWeekDate;
    }
  }


  // 计算2个日期相差的月份
   int _monthIndex(DateTime dateTime) {

    int yearMonths = (dateTime.year - this.initTime.year)*12;
    return yearMonths + (dateTime.month - this.initTime.month) + _kInitIndex;
  }


  // 计算2个日期相差的月份
   int _weekIndex(DateTime dateTime) {

    var nowFirstDate = this.initTime.add(Duration(days: -((this.initTime.weekday - (this.firstDayOfWeek % 7)) % 7)));

    var pageSpan = dateTime.difference(nowFirstDate).inDays / 7;

    return _kInitIndex + pageSpan.floor();
  }



  double getAspectRatio(DateTime dateTime, {CalendarShow show}) {

    if(show == null) {
      show = calendarShow;
    }
    if (show == CalendarShow.CalendarShowMonth) {

      var rowCount = getRowCount(dateTime.year, dateTime.month, firstDayOfWeek);
      return (7.0 / rowCount * childAspectRatio);
    } else {

      return (7.0 / 1 * childAspectRatio);
    }
  }


  static double aspectRatio(double childAspectRatio,int firstDayOfWeek, DateTime dateTime, CalendarShow show) {

    if (show == CalendarShow.CalendarShowMonth) {

      var rowCount = getRowCount(dateTime.year, dateTime.month, firstDayOfWeek);
      return (7.0 / rowCount * childAspectRatio);
    } else {

      return (7.0 / 1 * childAspectRatio);
    }
  }


  static int getRowCount(int year, int month, int firstDayOfWeek) {
    var firstWeekDay = DateTime(year, month, 1).weekday % 7;

    var lastMonthRestDayCount = (firstWeekDay - (firstDayOfWeek % 7)) % 7;
    var thisMonthDayCount = DateTime(year, month + 1, 0).day;

    return ((thisMonthDayCount + lastMonthRestDayCount) / 7.0).ceil();
  }


  static int getCurrentRow(int firstDayOfWeek, DateTime currentTime) {

    var firstWeekDay = DateTime(currentTime.year, currentTime.month, 1).weekday % 7;

    var lastMonthRestDayCount = (firstWeekDay - (firstDayOfWeek % 7)) % 7;
    var thisMonthDayCount = currentTime.day;

    return ((thisMonthDayCount + lastMonthRestDayCount) / 7.0).ceil();
  }



}

