

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'calendar_weekday.dart';
import 'calendar_sliver_delegate.dart';
import 'calendar_carousel.dart';


class CalendarScroll extends StatefulWidget {


  final DateTime startTime;  // 启始日期
  final DateTime endTime;  // 结束日期
  final DateTime currentPageTime;  // 当前要显示的日期, 默认当前时间

  final CurrentPageDate currentPageDate;

  final CalendarWeekday weekdayHeader;
  final DayWidgetBuilder dayWidgetBuilder;
  final double childAspectRatio;

  final CalendarController calendarController;
  final List<Widget> slivers;


  CalendarScroll({

    @required this.startTime,
    @required this.endTime,
    @required this.weekdayHeader,

    this.currentPageDate,
    this.dayWidgetBuilder,
    this.childAspectRatio = 1,
    calendarController,

    currentPageTime,
    pageController,
    this.slivers,

  }) :  assert(startTime != null),
        assert(endTime != null),
        assert(weekdayHeader != null),
        this.currentPageTime = currentPageTime ?? DateTime.now(),
        this.calendarController =  calendarController ?? CalendarController(),
        assert(!(currentPageTime.isBefore(startTime))),
        assert(!(endTime.isBefore(startTime))),
        assert(!(endTime.isBefore(currentPageTime)));


  @override
  _CalendarScrollState createState() => _CalendarScrollState();
}

class _CalendarScrollState extends State<CalendarScroll> with AutomaticKeepAliveClientMixin {

//  static final List<String> weekList = ["一","二","三","四","五","六","日"];
//
//  DateTime  _selectedDate = DateTime(2020, 9, 1);
//  ScrollController _controller =  ScrollController();
//  CalendarController _calendarController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    if(widget.calendarController )

//    _controller.addListener(() {
//
//
//
//      if (_controller.offset >= _controller.position.maxScrollExtent &&
//          !_controller.position.outOfRange) {
//
//
//      }
//      if (_controller.offset <= _controller.position.minScrollExtent &&
//          !_controller.position.outOfRange) {
//
//
//      }
//
//
//
//    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
//    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Widget build(BuildContext context) {

    super.build(context);

    print("=========== $widget.currentPageTime ");

    Widget calendarWidget =  SliverPersistentHeader(

      delegate: CalendarSliverDelegate(
        startTime: widget.startTime,
        endTime:widget.endTime,
        currentPageTime: widget.currentPageTime,
        weekdayHeader: widget.weekdayHeader,
        dayWidgetBuilder: widget.dayWidgetBuilder,
        calendarController: widget.calendarController,
        childAspectRatio: widget.childAspectRatio,
        currentPageDate: widget.currentPageDate,
      ),
      pinned: true,
    );

    List<Widget> child = List();

    child.add(calendarWidget);

    if(widget.slivers.length > 0) {
      child.addAll(widget.slivers);
    }

    return CustomScrollView(

      slivers: child,
    );
  }
}


