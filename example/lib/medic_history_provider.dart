import 'package:flutter/material.dart';

class MedicHistoryProvider with ChangeNotifier {

  MedicHistoryProvider();

  DateTime firstCurrentPageTime;

  setFirstCurrentPageTime(DateTime time) {

    if(firstCurrentPageTime != time) {
      firstCurrentPageTime = time;
      notifyListeners();
    }
  }

  setInitFirstDate(DateTime time) {
    firstCurrentPageTime = time;
  }



  DateTime secondCurrentPageTime;

  setSecondCurrentPageTime(DateTime time) {

    if(secondCurrentPageTime != time) {
      secondCurrentPageTime = time;
      notifyListeners();
    }
  }

  setSecondInitDate(DateTime time) {
    secondCurrentPageTime = time;
  }

}
