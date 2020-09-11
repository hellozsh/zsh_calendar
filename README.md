# zsh_calendar

A new Flutter package project.

## 日历组件，支持周日切换，支持滑动收缩，支持上下页跳转，支持跳到某个日期，支持边界效果， 日历中每个日期、周的widget都可自定义

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.


@[TOC](zsh_calendar 日历组件，支持周日切换，支持滑动收缩，支持上下页跳转，支持跳到某个日期，支持边界效果， 日历中每个日期、周的widget都可自定义)

附上
github [地址:](https://github.com/hellozsh/zsh_calendar) 
pub.dev [地址](https://pub.dev/packages?q=zsh_calendar)
# 效果
可高度自定义的日历，日历中每个日期、周都可以自定义样式，
实现了

1. 项目1跳转到某个日期功能，
2. 上下月跳转功能
3. 左右滑动切换功能
4. 周日历和月日历切换功能
5. 上下滑动收缩功能

效果1:
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200911190227595.gif#pic_center)
效果2:
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200911190241831.gif#pic_center)
#  使用方法
## 导入文件
方式1: 将代码下载下来，将里面的lib/src下的文件夹导入到自己的项目中
方式2: pubspec.yaml 添加
```javascript
dependencies:
  zsh_calendar: ^0.0.1
```
然后控制台执行: flutter pub get 既可

## 使用 
在要使用zsh_calendar的地方写: 

```javascript
import 'package:zsh_calendar/zsh_calendar.dart';
```
带收缩日历用CalendarSliverDelegate，他是SliverPersistentHeader的代理，外层用CustomScrollView包裹，
如下：
```javascript
CustomScrollView(

          slivers: [
            Consumer<MedicHistoryProvider>(
                builder: (context, MedicHistoryProvider counter, _) {

                  return  SliverPersistentHeader(

                    delegate: CalendarSliverDelegate(
                      startTime: DateTime(2020, 2, 3),
                      endTime: DateTime(2021, 2, 3),
                      currentPageTime: counter.firstCurrentPageTime,
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

                        bool isSame = date.year == Provider.of<MedicHistoryProvider>(context, listen: false).firstCurrentPageTime.year
                            && date.month == Provider.of<MedicHistoryProvider>(context, listen: false).firstCurrentPageTime.month
                            && date.day == Provider.of<MedicHistoryProvider>(context, listen: false).firstCurrentPageTime.day;

                        return InkWell(

                          child: Column(
                            children: <Widget>[

                              Container(

                                  margin: EdgeInsets.only(top: (MediaQuery.of(context).size.width/7-10)/4),
                                  width: (MediaQuery.of(context).size.width/7-10)/2,
                                  height: (MediaQuery.of(context).size.width/7-10)/2,
                                  decoration: isSame ? BoxDecoration(
                                    borderRadius: BorderRadius.circular((MediaQuery.of(context).size.width/7-10)/2),
                                    color: Colors.yellow,
                                  ) : null,
                                  child: Center(
                                    child: Text(
                                      date.day.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isSame ? Colors.white : Colors.blue,
                                      ),
                                    ),
                                  )
                              ),
                              Offstage(
                                offstage: isLastMonthDay || isNextMonthDay,
                                child: Container(

                                  margin: EdgeInsets.only(top: 2),
                                  decoration: BoxDecoration(

                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.yellow,
                                  ),
                                  width: 5,
                                  height: 5,
                                ),
                              )
                            ],
                          ),
                          onTap: (){
                            historyProvider.setFirstCurrentPageTime(date);
                            _calendarController.goToDate(dateTime: date);

                          },
                        );
                      },
                      currentPageDate: (DateTime pageTime) {

                        historyProvider.setFirstCurrentPageTime(pageTime);

                      },
                    ),
                    pinned: true,
                  );
                }),

           
          ],
        ),
```

不带收缩功能的，用CalendarCarousel组件，参数和上面一样，shrinkageHeight不需要设置，除非你想要它收缩

 ![在这里插入图片描述](https://img-blog.csdnimg.cn/20200911185651872.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2FpX3BwbGU=,size_16,color_FFFFFF,t_70#pic_center)

# 更多效果以及完整代码在[github](https://github.com/hellozsh/zsh_calendar)