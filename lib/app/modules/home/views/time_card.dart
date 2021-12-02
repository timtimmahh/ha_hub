import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ha_hub/app/modules/home/controllers/home_controller.dart';
import 'package:ha_hub/app/modules/home/views/current_time_counter.dart';
import 'package:intl/intl.dart';

class TimeCard extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) => /*Card(
      child: */
      CurrentTimeCounter(
          builder: (dateTime) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: Text(
                            Get.find<DateFormat>(tag: 'dateFormat')
                                .format(dateTime),
                            style: Get.textTheme.headline4)),
                    Container(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text(
                            Get.find<DateFormat>(tag: 'timeFormat')
                                .format(dateTime),
                            style: Get.textTheme.headline2!.copyWith(
                                // color: Colors.black87,
                                fontWeight: FontWeight.normal,
                                letterSpacing: -1.5)))
                  ])) /*)*/;
}
