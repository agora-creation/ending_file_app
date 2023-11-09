import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const kWhiteColor = Color(0xFFFFFFFF);
const kBlackColor = Color(0xFF333333);
const kGreyColor = Color(0xFF9E9E9E);
const kRedColor = Color(0xFFF44336);
const kBlueColor = Color(0xFF2196F3);

ThemeData customTheme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.transparent,
    fontFamily: 'OradanoGSRR',
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(
        color: kWhiteColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: kWhiteColor),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: kWhiteColor,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: kWhiteColor,
        fontSize: 16,
      ),
      bodySmall: TextStyle(
        color: kWhiteColor,
        fontSize: 16,
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    unselectedWidgetColor: kGreyColor,
  );
}

const kBgDecoration = BoxDecoration(
  image: DecorationImage(
    image: AssetImage('assets/images/background.jpg'),
    fit: BoxFit.cover,
    alignment: Alignment.centerRight,
    opacity: 0.8,
  ),
);
