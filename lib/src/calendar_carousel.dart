
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'calendar_weekday.dart';
import 'calendar_physics.dart';
import 'calendar_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef Widget DayWidgetBuilder(DateTime date, bool isLastMonthDay, bool isNextMonthDay);

typedef void CurrentPageDate(DateTime dateTime);


class CalendarCarousel extends StatefulWidget {

  final DateTime startTime;  // 启始日期
  final DateTime endTime;  // 结束日期
  final DateTime currentPageTime;  // 当前要显示的日期, 默认当前时间

  final DateTime centerTime; // 收缩的时候想要显示在中心的时间,默认是这个月1日

  final CurrentPageDate currentPageDate;

  final CalendarWeekday weekdayHeader;
  final DayWidgetBuilder dayWidgetBuilder;
  final double childAspectRatio;

  final CalendarShow calendarShow;
  final CalendarController calendarController;

  final double shrinkageHeight;  // 需要收缩的高度

  CalendarCarousel({
    Key key,
    @required this.startTime,
    @required this.endTime,
    @required this.weekdayHeader,

    this.currentPageDate,
    this.dayWidgetBuilder,
    this.childAspectRatio = 1,
    this.calendarShow = CalendarShow.CalendarShowMonth,
    this.calendarController,
    this.shrinkageHeight = 1,
    this.centerTime,

    currentPageTime,
    pageController,
  }) :  assert(startTime != null),
        assert(endTime != null),
        assert(weekdayHeader != null),
        this.currentPageTime = currentPageTime ?? DateTime.now(),
        assert(!(currentPageTime.isBefore(startTime))),
        assert(!(endTime.isBefore(startTime))),
        assert(!(endTime.isBefore(currentPageTime))),
        super(key: key);

  @override
  _CalendarCarouselState createState() => _CalendarCarouselState();
}

class _CalendarCarouselState extends State<CalendarCarousel> with TickerProviderStateMixin {

  PageController _pageController;
  CalendarScrollPhysics _scrollPhysics;
  ScrollController _monthController;

  CalendarUtil  _calendarUtil;
  CalendarController _calendarController;
//  DateTime currentPageTime;
  double _aspectRatio = 1;
  double _monthRatio = 1;
  double _weekRatio = 1;

  @override
  void initState() {

    _calendarUtil = CalendarUtil(
      initTime: widget.currentPageTime,
      firstDayOfWeek: widget.weekdayHeader.firstDayOfWeek,
      childAspectRatio: widget.childAspectRatio,
      calendarShow: widget.calendarShow,
    );
    _pageController = PageController(
      viewportFraction: 1,
      initialPage: _calendarUtil.initIndex(),
      keepPage: false,
    );

    _monthController = ScrollController(
      keepScrollOffset: true,
    );

    _calendarController = widget.calendarController ?? CalendarController();
    _calendarController._pageController = _pageController;
    _calendarController._calendarUtil = _calendarUtil;
    _calendarController._changeCalendarShow = _changeCalendarShow;
    _calendarController._updateOffset = _updateOffset;

    _scrollPhysics = CalendarScrollPhysics(Status(), _calendarUtil);

    _calendarController._scrollPhysics = _scrollPhysics;

    _monthRatio = _calendarUtil.getAspectRatio(widget.currentPageTime, show: CalendarShow.CalendarShowMonth);
    _weekRatio = _calendarUtil.getAspectRatio(widget.currentPageTime, show: CalendarShow.CalendarShowWeek);
    _aspectRatio =  _calendarUtil.calendarShow == CalendarShow.CalendarShowMonth ? _monthRatio : _weekRatio;

    super.initState();


    // 修改最大最小范围
    _setScrollPhysicMaxMin();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _monthController.dispose();
    _calendarController.dispose();
  }


  _changeCalendarShow(CalendarShow calendarShow, DateTime dateTime) {

    Future.delayed(Duration.zero, () {

      var date = dateTime ?? widget.currentPageTime;

      _calendarUtil.calendarShow = calendarShow;

      var currentPage = _calendarUtil.indexOf(date);
      _pageController.jumpToPage(currentPage);
      _aspectRatio =  _calendarUtil.calendarShow == CalendarShow.CalendarShowMonth ? _monthRatio : _calendarUtil.getAspectRatio(widget.currentPageTime, show: CalendarShow.CalendarShowWeek);
      _setScrollPhysicMaxMin();
      _updateOffset();
//      setState(() {
//
//
//        // 更新ziview的位移
//        _updateOffset();
//      });

    });
  }


//  @override
//  void didUpdateWidget(CalendarCarousel oldWidget) {
//    // TODO: implement didUpdateWidget
//    super.didUpdateWidget(oldWidget);
//
//    // 更新ziview的位移
//    _updateOffset();
////    if(_aspectRatio >=_weekRatio && _calendarUtil.calendarShow != CalendarShow.CalendarShowWeek) {
////
////      print("=============== CalendarShowWeek _weekRatio=$_weekRatio _aspectRatio=$_aspectRatio _monthRatio =$_monthRatio");
//////      _changeCalendarShow(CalendarShow.CalendarShowWeek, currentPageTime);
////    } else if( _aspectRatio < _weekRatio-0.1 && _calendarUtil.calendarShow != CalendarShow.CalendarShowMonth) {
////
////      print("=============== CalendarShowMonth _weekRatio=$_weekRatio _aspectRatio=$_aspectRatio _monthRatio =$_monthRatio");
//////      _changeCalendarShow(CalendarShow.CalendarShowMonth, currentPageTime);
////    }
//
//  }

  @override
  Widget build(BuildContext context) {

    print("================  build");
    return Column(
      children: <Widget>[
        Offstage(
          offstage: widget.weekdayHeader.builder == null,
          child: _weekDayWidget(),
        ),
        _calendarDayWidget(),

      ],
    );
  }

  Widget _calendarDayWidget() {

    double shrinRatio = ScreenUtil.screenWidth / (ScreenUtil.screenWidth / _monthRatio - widget.shrinkageHeight);

    shrinRatio = double.parse((shrinRatio).toStringAsFixed(14));

    // 更新ziview的位移
    _updateOffset();


//    if(_aspectRatio >=_weekRatio && _calendarUtil.calendarShow != CalendarShow.CalendarShowWeek) {
//
//      print("=============== CalendarShowWeek  currentPageTime = ${widget.currentPageTime} _weekRatio=$_weekRatio shrinRatio=$_aspectRatio");
////      _changeCalendarShow(CalendarShow.CalendarShowWeek, currentPageTime);
//    } else if( _aspectRatio < _weekRatio-0.1 && _calendarUtil.calendarShow != CalendarShow.CalendarShowMonth) {
//
//      print("=============== CalendarShowMonth  currentPageTime = ${widget.currentPageTime} _weekRatio=$_weekRatio shrinRatio=$_aspectRatio");
//
////      _changeCalendarShow(CalendarShow.CalendarShowMonth, currentPageTime);
//    }

    if( _calendarUtil.calendarShow == CalendarShow.CalendarShowMonth) {
      _aspectRatio = shrinRatio;
    } else {
        _aspectRatio = _weekRatio;
    }

    return AspectRatio(

      aspectRatio:_aspectRatio, //  MediaQuery.of(context).size.width / _aspectRatio
      child: PageView.builder(
        onPageChanged: _pageChanged,
        controller: _pageController,
        physics: _scrollPhysics,
        itemBuilder:(BuildContext context,int index) {


//         return IndexedStack(
//            index: _calendarUtil.calendarShow == CalendarShow.CalendarShowMonth ? 0 : 1,
//            children: <Widget>[
//              _monthView(index),
//              _weekView(index),
//            ],
//          );
          if(_calendarUtil.calendarShow == CalendarShow.CalendarShowMonth) {

            print("=============  month");
            return _monthView(index);
          } else {

            print("============= week");
            return _weekView(index);
          }
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }


  Widget _monthView(int index) {

    DateTime time =  _calendarUtil.getActualDate(index, widget.currentPageTime);
    if(_calendarUtil.calendarShow == CalendarShow.CalendarShowWeek) {
      time = DateTime(widget.currentPageTime.year, widget.currentPageTime.month, 1);
    }

    int year = time.year;
    int month = time.month;
    var firstWeekDay = DateTime(year, month, 1).weekday % 7;
    var lastMonthRestDayCount = (firstWeekDay - (widget.weekdayHeader.firstDayOfWeek % 7)) % 7;

    var thisMonthDayCount = DateTime(year, month + 1, 0).day;
    var lastMonthDayCount = DateTime(year, month, 0).day;
    /// 行数
    var rowCount = ((thisMonthDayCount + lastMonthRestDayCount) / 7.0).ceil();

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: GridView.builder(

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: widget.childAspectRatio,

        ),
        itemCount: rowCount * 7,
        itemBuilder: (BuildContext context, int index) {
          var currentDay = index + 1 - lastMonthRestDayCount;
          // last month day
          var isLastMonthDay = false;
          // next month day
          var isNextMonthDay = false;

          var currentMonth = month;
          if (currentDay <= 0) {
            isLastMonthDay = true;
            currentDay = lastMonthDayCount + currentDay;
            currentMonth -= 1;
          } else if (currentDay > thisMonthDayCount) {
            isNextMonthDay = true;
            currentDay = currentDay - thisMonthDayCount;

            currentMonth += 1;
          }
          //
          return widget.dayWidgetBuilder(DateTime(year, currentMonth, currentDay), isLastMonthDay, isNextMonthDay);
        },

        controller: _monthController,
        physics: NeverScrollableScrollPhysics(),

      ),
    );
  }


  Widget grid() {

//    GridView.count(
//      crossAxisCount: 7,
//      childAspectRatio: widget.childAspectRatio,
//      controller: _monthController,
//      physics: NeverScrollableScrollPhysics(),
//      children: List.generate(rowCount * 7, (index) {
//
//        var currentDay = index + 1 - lastMonthRestDayCount;
//        // last month day
//        var isLastMonthDay = false;
//        // next month day
//        var isNextMonthDay = false;
//
//        var currentMonth = month;
//        if (currentDay <= 0) {
//          isLastMonthDay = true;
//          currentDay = lastMonthDayCount + currentDay;
//          currentMonth -= 1;
//        } else if (currentDay > thisMonthDayCount) {
//          isNextMonthDay = true;
//          currentDay = currentDay - thisMonthDayCount;
//
//          currentMonth += 1;
//        }
//        //
//        return widget.dayWidgetBuilder(DateTime(year, currentMonth, currentDay), isLastMonthDay, isNextMonthDay);
//      }),
//    ),
  }


  Widget _weekView(int index) {

    DateTime currentDate =  _calendarUtil.getActualDate(index, widget.currentPageTime);

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: GridView.count(
//        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 7,
        childAspectRatio: widget.childAspectRatio,
        children: List.generate(7, (index) {
          // 左边的日期个数
          var leftCount = (currentDate.weekday % 7) - (widget.weekdayHeader.firstDayOfWeek % 7);

          var date = currentDate.add(Duration(days: index - leftCount));

          // last month day
          var isLastMonthDay = date.month < currentDate.month;
          // next month day
          var isNextMonthDay = date.month > currentDate.month;
          return widget.dayWidgetBuilder(date, isLastMonthDay, isNextMonthDay);
        }),
      ),
    );
  }


  _pageChanged(int index) {


    DateTime currentTime = widget.currentPageTime;
    if(_calendarController._currentTime != null) {

      currentTime = _calendarController._currentTime;
      _calendarController._currentTime = null;
    }
    DateTime currentPageTime  = _calendarUtil.getActualDate(index, currentTime);

    if(currentPageTime.isBefore(widget.startTime)) {
      currentPageTime = widget.startTime;
    }

    _monthRatio = _calendarUtil.getAspectRatio(currentPageTime, show: CalendarShow.CalendarShowMonth);
    _weekRatio = _calendarUtil.getAspectRatio(currentPageTime, show: CalendarShow.CalendarShowWeek);
    _aspectRatio =  _calendarUtil.calendarShow == CalendarShow.CalendarShowMonth ? _monthRatio : _weekRatio;
    if(widget.currentPageDate != null) {
      widget.currentPageDate(currentPageTime);
    }

//    setState(() {
//
//    });
  }


  _setScrollPhysicMaxMin() {

    int startIndex = _calendarUtil.indexOf(widget.startTime);
    int endIndex = _calendarUtil.indexOf(widget.endTime);

    print("================ startIndex=$startIndex  endIndex=$endIndex");
    _scrollPhysics.status.minScrollExtent = ScreenUtil.screenWidth * _calendarUtil.indexOf(widget.startTime);
    _scrollPhysics.status.maxScrollExtent = ScreenUtil.screenWidth * _calendarUtil.indexOf(widget.endTime);
  }

  List<Widget> _renderWeekDays() {
    var list = [];
    for (int i = 0; i < 7; i++) {
      var weekday = (widget.weekdayHeader.firstDayOfWeek + i) % 7;
      if (weekday == 0) weekday = 7;
      list.add(weekday);
    }
    return list.map((i) => widget.weekdayHeader.builder(i)).toList();
  }

  Widget _weekDayWidget(){

    return Container(
      width: double.infinity,
      height: widget.weekdayHeader.height,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _renderWeekDays(),
      ),
    );
  }


  void _updateOffset(){


    if(widget.shrinkageHeight == 0 || _calendarUtil.calendarShow == CalendarShow.CalendarShowWeek) return;

    // 选中的日期在第几行，
    var currentRow = CalendarUtil.getCurrentRow(widget.weekdayHeader.firstDayOfWeek, widget.currentPageTime);
    // 一共有几行
    var rowCount = CalendarUtil.getRowCount(widget.currentPageTime.year, widget.currentPageTime.month, widget.weekdayHeader.firstDayOfWeek);
    // 上面几行,上面占用百分比
    double persent = (currentRow-1.0)/(rowCount-1.0);

    double offset = persent*widget.shrinkageHeight;


    if(_monthController.hasClients) {

      print("========== jumpTo $offset");
      _monthController.jumpTo(offset);

    } else {

      print("失败失败=============失败失败   $offset");
//      Future.delayed(Duration(milliseconds: 1), () {
//        _updateOffset();
//      });
    }

  }
}




typedef void ChangeCalendarShow(CalendarShow calendarShow, DateTime dateTime);

typedef double GetMaxHeight();

typedef double GetMinHeight();

typedef void UpdateOffset();


class CalendarController extends ChangeNotifier {

  ChangeCalendarShow _changeCalendarShow;

  PageController _pageController;
  CalendarUtil _calendarUtil;
  UpdateOffset _updateOffset;
  CalendarScrollPhysics _scrollPhysics;
  DateTime _currentTime;

  nextPage({
    Duration duration,
    Curve curve = Curves.bounceInOut
  }) {

    int index = (_pageController.page + 1).toInt();
    double width = ScreenUtil.screenWidth * index;
    if(_scrollPhysics.status.minScrollExtent > width) {
      return;
    } else if(_scrollPhysics.status.maxScrollExtent < width) {
      return;
    }

    if (duration != null) {
      _pageController.nextPage(
          duration: duration,
          curve: curve
      );
    } else {
      _pageController.jumpToPage(index);
    }
  }

  previousPage({
    Duration duration,
    Curve curve = Curves.bounceInOut
  }) {

    int index = (_pageController.page - 1).toInt();
    double width = ScreenUtil.screenWidth * index;
    if(_scrollPhysics.status.minScrollExtent > width) {
      return;
    } else if(_scrollPhysics.status.maxScrollExtent < width) {
      return;
    }

    if (duration != null) {
      _pageController.previousPage(
          duration: duration,
          curve: curve
      );
    } else {
      _pageController.jumpToPage(index);
    }
  }


  goToToday({
    Duration duration,
    Curve curve = Curves.bounceInOut
  }) {
    var now = DateTime.now();
    goToDate(dateTime: now, duration: duration, curve: curve);
  }

  goToDate({
    @required DateTime dateTime,
    Duration duration,
    Curve curve = Curves.bounceInOut
  }) {

    _currentTime = dateTime;
    int index = _calendarUtil.indexOf(dateTime);

    double width = ScreenUtil.screenWidth * index;
    if(_scrollPhysics.status.minScrollExtent > width) {
      return;
    } else if(_scrollPhysics.status.maxScrollExtent < width) {
      return;
    }

    if (duration != null) {
      _pageController.animateToPage(
          index,
          duration: duration,
          curve: curve
      );
    } else {
      _pageController.jumpToPage(index);
    }
  }

  changeCalendarShow(CalendarShow calendarShow, DateTime dateTime) {

    if (_changeCalendarShow != null) {
      _changeCalendarShow(calendarShow, dateTime);
    }
  }

  double getMaxHeight(double childAspectRatio,int firstDayOfWeek, DateTime currentSelectedTime) {

    double radio = CalendarUtil.aspectRatio(childAspectRatio, firstDayOfWeek, currentSelectedTime, CalendarShow.CalendarShowMonth);
    return ScreenUtil.screenWidth / radio;
  }

  double getMinHeight(double childAspectRatio,int firstDayOfWeek, DateTime currentSelectedTime) {

    double radio = CalendarUtil.aspectRatio(childAspectRatio, firstDayOfWeek, currentSelectedTime, CalendarShow.CalendarShowWeek);
    return ScreenUtil.screenWidth / radio;
  }

  void updateOffset(){

    if (_updateOffset != null) {
      _updateOffset();
    }
  }


}