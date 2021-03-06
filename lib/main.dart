import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

Typography get customTypography => Typography.material2018(
    platform: null,
    black: Typography.blackHelsinki,
    white: Typography.whiteHelsinki,
    englishLike: Typography.englishLike2018,
    dense: Typography.dense2018,
    tall: Typography.tall2018);

void main() {
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        colorScheme: ColorScheme.light(),
        scaffoldBackgroundColor: Colors.white,
        backgroundColor: Colors.white,
        fontFamily: 'Roboto',
        typography: customTypography,
        // textTheme: TextTheme(headline2: TextStyle),
        cardTheme: CardTheme(
          // color: Colors.white,
          elevation: 20.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      darkTheme: ThemeData(
          colorScheme: ColorScheme.dark(surface: Colors.black, background: Colors.black),
          fontFamily: 'Roboto',
          scaffoldBackgroundColor: Colors.black,
          backgroundColor: Colors.black,
          typography: customTypography,
          cardTheme: CardTheme(
              color: Color(0xFF101010),
              elevation: 20.0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)))),
      themeMode: ThemeMode.light,
    ),
  );
}
