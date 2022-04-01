import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ha_hub/app/modules/home/controllers/home_controller.dart';
import 'package:ha_hub/exts/widget_exts.dart';

class CalendarCard extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) => Card(child: [IndexedStack().contain()].column());
}
