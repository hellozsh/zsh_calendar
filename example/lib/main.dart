

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'medic_history_provider.dart';
import 'index.dart';

// 一定要初始化screenutil

void main() {

  runApp(MyApp());
}


class MyApp extends StatefulWidget {

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MedicHistoryProvider()),
      ],
      child:  MaterialApp(
        debugShowCheckedModeBanner: false,

        home: Scaffold(

          appBar: AppBar(
            elevation: 0,
            title: Text("zh_calendar操作指南",),
          ),
          body: IndexPath(),
        ),
      ),
    );
  }


}




// 可以做一些初始化操作，做完后跳转页面
