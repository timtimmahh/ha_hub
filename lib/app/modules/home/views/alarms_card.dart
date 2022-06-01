import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ha_hub/app/modules/home/controllers/home_controller.dart';
import 'package:ha_hub/app/modules/home/data/alarm_models.dart';
import 'package:ha_hub/exts/widget_exts.dart';

class AlarmsCard extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) => ObxValue<RxList<Alarm>>(
      (alarms) => ListView.builder(itemBuilder: (context, index) => ListTile(
            leading: Icons.alarm.icon(),
            title: alarms[index].nextAlarmTimeString.asText(),
            onTap: () {},
          ).contain(padding: EdgeInsets.only(top: 8.0))),
      controller.alarms);
}
