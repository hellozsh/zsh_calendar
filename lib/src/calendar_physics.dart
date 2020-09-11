

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'calendar_util.dart';


class Status {

  double minScrollExtent;
  double maxScrollExtent;
}

class CalendarScrollPhysics extends ScrollPhysics {

  final Status status;
  final CalendarUtil calendarUtil;

  CalendarScrollPhysics(this.status, this.calendarUtil, {ScrollPhysics parent})
      : super(parent: parent);

  @override
  CalendarScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CalendarScrollPhysics(this.status, this.calendarUtil, parent: buildParent(ancestor));
  }


  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return offset;
  }


  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    //print("applyBoundaryConditions");
    assert(() {
      if (value == position.pixels) {
        throw FlutterError(
            '$runtimeType.applyBoundaryConditions() was called redundantly.\n'
                'The proposed new position, $value, is exactly equal to the current position of the '
                'given ${position.runtimeType}, ${position.pixels}.\n'
                'The applyBoundaryConditions method should only be called when the value is '
                'going to actually change the pixels, otherwise it is redundant.\n'
                'The physics object in question was:\n'
                '  $this\n'
                'The position object in question was:\n'
                '  $position\n');
      }
      return true;
    }());

    if (value < position.pixels && position.pixels <= this.status.minScrollExtent)
    {
      return value - position.pixels;
    }

    if (this.status.maxScrollExtent <= position.pixels && position.pixels < value)
        {
      return value - position.pixels;
    }

    if (value < this.status.minScrollExtent &&
        this.status.minScrollExtent < position.pixels) // hit top edge
        {
      return value - this.status.minScrollExtent;
    }


    if (position.pixels < this.status.maxScrollExtent &&
        this.status.maxScrollExtent < value) // hit bottom edge
        {
      return value - this.status.maxScrollExtent;
    }

    return 0.0;
  }


}