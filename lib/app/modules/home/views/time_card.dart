import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ha_hub/app/modules/home/controllers/home_controller.dart';
import 'package:ha_hub/app/modules/home/views/alarms_card.dart';
import 'package:ha_hub/app/modules/home/views/current_time_counter.dart';
import 'package:ha_hub/exts/widget_exts.dart';
import 'package:intl/intl.dart';

class TimeCard extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) => [
        CurrentTimeCounter(
            builder: (dateTime) => [
                  Get.find<DateFormat>(tag: 'dateFormat')
                      .format(dateTime)
                      .asText(style: Get.textTheme.headline4)
                      .contain(padding: EdgeInsets.only(bottom: 4.0)),
                  Get.find<DateFormat>(tag: 'timeFormat')
                      .format(dateTime)
                      .asText(style: Get.textTheme.headline2!)
                      .contain(padding: EdgeInsets.only(top: 4.0))
                ].linear(crossAxisAlignment: CrossAxisAlignment.start)).expanded(flex: 2),
        AlarmsCard().expanded(flex: 4),
        Icons.alarm_add.button(onPressed: () {}, iconSize: 36.0).contain().expanded(flex: 1)
      ].linear();
}
