
//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zsh_calendar/zsh_calendar.dart';
import 'package:provider/provider.dart';
import 'medic_history_provider.dart';

class MonthWeekCalendar extends StatefulWidget {
  @override
  _MonthWeekCalendarState createState() => _MonthWeekCalendarState();
}

class _MonthWeekCalendarState extends State<MonthWeekCalendar> with AutomaticKeepAliveClientMixin {

  static final List<String> weekList = ["一","二","三","四","五","六","日"];

  CalendarController _calendarController = CalendarController();
  CalendarShow _show = CalendarShow.CalendarShowMonth;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Provider.of<MedicHistoryProvider>(context, listen: false).setSecondInitDate(DateTime(2020, 9, 1));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    var historyProvider = Provider.of<MedicHistoryProvider>(context);

    return Column(
      children: <Widget>[

        appBar(context, (date) {
          _calendarController.goToDate(dateTime: date);
        }),
                    Consumer<MedicHistoryProvider>(
                builder: (context, MedicHistoryProvider counter, _) {

                  return CalendarCarousel(

                    startTime: DateTime(2020, 2, 3),
                    endTime: DateTime(2021, 2, 3),
                    currentPageTime: counter.secondCurrentPageTime,
                    calendarController: _calendarController,
                    weekdayHeader: CalendarWeekday(
                        7,
                        30,
                        builder: (int weekday) {
                          return Container(
                            child: Text(
                              weekList[weekday-1],
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          );
                        }
                    ),
                    dayWidgetBuilder:(DateTime date, bool isLastMonthDay, bool isNextMonthDay) {

                      bool isSame = date.year == Provider.of<MedicHistoryProvider>(context, listen: false).secondCurrentPageTime.year
                          && date.month == Provider.of<MedicHistoryProvider>(context, listen: false).secondCurrentPageTime.month
                          && date.day == Provider.of<MedicHistoryProvider>(context, listen: false).secondCurrentPageTime.day;

                      return InkWell(

                        child: Column(
                          children: <Widget>[

                            Container(

                                margin: EdgeInsets.only(top: (MediaQuery.of(context).size.width/7-10)/4),
                                width: (MediaQuery.of(context).size.width/7-10)/2,
                                height: (MediaQuery.of(context).size.width/7-10)/2,

                                child: Center(
                                  child: Text(
                                    isSame ? "中" : date.day.toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isSame ? Colors.red : Colors.blue,
                                    ),
                                  ),
                                )
                            ),
                            Offstage(
                              offstage: isLastMonthDay || isNextMonthDay,
                              child: Container(

                                margin: EdgeInsets.only(top: 2),

                                decoration: date.day % 2 == 0 ? BoxDecoration(

                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.yellow,
                                ) : null,
                                width: 5,
                                height: 5,
                              ),
                            ),

                          ],
                        ),
                        onTap: (){
                          historyProvider.setSecondCurrentPageTime(date);
                          _calendarController.goToDate(dateTime: date);

                        },
                      );
                    },
                    currentPageDate: (DateTime pageTime) {

                      historyProvider.setSecondCurrentPageTime(pageTime);

                    },
                  );
                }),

        Expanded(child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Container(

              padding: EdgeInsets.only(left: 15),

              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '阿斯皮',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: ["4mg",'3mg'].map((e) {
                          return Container(

                            child: Padding(
                              padding: EdgeInsets.only(top: 10,bottom: 10),
                              child: Text('$e',style: TextStyle(
                                fontSize: 15,
                              ),
                                textAlign: TextAlign.right,),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Expanded(
                    child:Column(
                      children: [['08:00',"09:00","10:00"]].map((e) {
                        return Padding(
                          padding: EdgeInsets.only(top: 10,bottom: 10),
                          child: Text('$e',style: TextStyle(
                            fontSize: 15,

                          ),),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: 14,

        ),),
      ],
    );
  }

  Widget appBar(BuildContext context,Function(DateTime date) selectedDateBack) {

    DateTime _selectedDate;

    return Row(

      children: <Widget>[
        FlatButton(
            onPressed: (){

              if(selectedDateBack != null) {
                selectedDateBack(DateTime(2020,9,16));
              }
            },
            child:Container(
              width: 100,
              child:  Text(
                '跳到2020年9月16日',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            )

        ),


        InkWell(
            child: Text(
              " 《 ",
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            onTap: () {

              _calendarController.previousPage();
            }),
        Consumer<MedicHistoryProvider>(
            builder: (context, MedicHistoryProvider counter, _) {


              return  Text(


                '${counter.secondCurrentPageTime.year}-${counter.secondCurrentPageTime.month}-${counter.secondCurrentPageTime.day}',

                style: TextStyle(
                    fontSize: 17,
                    color: Colors.blue
                ),
                textAlign: TextAlign.center,
              );
            }),
        InkWell(
            child: Text(
              " 》 ",
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            onTap: () {

              _calendarController.nextPage();
            }),

        FlatButton(
            child: Row(
              children: <Widget>[


                Text(
                  _show == CalendarShow.CalendarShowMonth ? '周试图' : "月试图",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            onPressed: () {

              if(_show == CalendarShow.CalendarShowMonth) {
                _show = CalendarShow.CalendarShowWeek;
              } else {
                _show = CalendarShow.CalendarShowMonth;
              }
              setState(() {

              });
              _calendarController.changeCalendarShow(_show, Provider.of<MedicHistoryProvider>(context, listen: false).secondCurrentPageTime);
            }),

      ],
    );
  }



  Widget sliderList() {

    return SliverList(

        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return Container(

              padding: EdgeInsets.only(left: 15),

              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '阿斯皮',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: ["4mg",'3mg'].map((e) {
                          return Container(

                            child: Padding(
                              padding: EdgeInsets.only(top: 10,bottom: 10),
                              child: Text('$e',style: TextStyle(
                                fontSize: 15,
                              ),
                                textAlign: TextAlign.right,),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Expanded(
                    child:Column(
                      children: [['08:00',"09:00","10:00"]].map((e) {
                        return Padding(
                          padding: EdgeInsets.only(top: 10,bottom: 10),
                          child: Text('$e',style: TextStyle(
                            fontSize: 15,
                          ),),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
          childCount:14,
        )
    );
  }
}





