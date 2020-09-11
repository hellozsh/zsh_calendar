import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'month_week_calendar.dart';
import 'scroll_month_calendar.dart';

//类似广告启动页
class IndexPath extends StatefulWidget {
  @override
  _IndexPathState createState() => _IndexPathState();
}

class _IndexPathState extends State<IndexPath> with SingleTickerProviderStateMixin  {

  TabController _tabController;
  var tabs = ["收缩日历", "周月日历"];
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: tabs.length);
  }

  @override
  Widget build(BuildContext context) {


    ScreenUtil.init(context,
      width: 375,
      height: 667,
      allowFontScaling: false,
    );

    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(width: 1, color: Colors.white)),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 0),
                        color: Color.fromARGB(10, 0, 0, 0),
                        blurRadius: 2.0,
                        spreadRadius: 4.0)
                  ]),
              child: _tabbarTitle()),
          Expanded(child: _tabbarView())
        ],
      ),
    );
  }

  Widget _tabbarTitle() {
    return Container(
        child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.blue,
            labelStyle: TextStyle(
              fontSize: 16,
            ),
            indicatorWeight: 2,
            unselectedLabelColor: Colors.grey,
            tabs: tabs.map((tab) {
              return Tab(
                key: Key(tab),
                text: tab,
              );
            }).toList()));
  }

  Widget _tabbarView() {
    return TabBarView(
        controller: _tabController,
        // ignore: missing_return
        children: tabs.map((tab) {
          switch (tab) {
            case "收缩日历":
              return ScrollMonthCalendar();
            case "周月日历":
              return MonthWeekCalendar();

          }
        }).toList());
  }

}
