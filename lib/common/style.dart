import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

const kWhiteColor = Color(0xFFFFFFFF);
const kBlackColor = Color(0xFF333333);
const kGreyColor = Color(0xFF9E9E9E);
const kRedColor = Color(0xFFF44336);
const kBlueColor = Color(0xFF2196F3);
const kYellowColor = Color(0xFFFFEB3B);

ThemeData customTheme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.transparent,
    fontFamily: 'ZenOldMincho-Regular',
    appBarTheme: const AppBarTheme(
      color: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(
        color: kWhiteColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'ZenOldMincho-Regular',
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

const kLockErrorStyle = TextStyle(
  color: kRedColor,
  fontSize: 14,
);

final kBorderDecoration = BoxDecoration(
  border: Border.all(color: kWhiteColor),
  borderRadius: BorderRadius.circular(8),
);

const kBgDecoration = BoxDecoration(
  image: DecorationImage(
    image: AssetImage('assets/images/background.jpg'),
    fit: BoxFit.cover,
    alignment: Alignment.centerRight,
    opacity: 0.6,
  ),
);

const kGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisSpacing: 4,
  mainAxisSpacing: 4,
  crossAxisCount: 3,
);

const kScreenLockConfig = ScreenLockConfig(
  backgroundColor: kBlackColor,
);

final kKeyPadConfig = KeyPadConfig(
  buttonConfig: KeyPadButtonConfig(
    foregroundColor: kWhiteColor,
    buttonStyle: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(100),
        ),
      ),
      side: const BorderSide(color: kWhiteColor),
    ),
  ),
);

const List<String> imageExtensions = [
  '.HEIC',
  '.heic',
  '.JPEG',
  '.jpeg',
  '.JPG',
  '.jpg',
  '.GIF',
  '.gif',
  '.PNG',
  '.png',
];
const List<String> videoExtensions = [
  '.MP4',
  '.mp4',
  '.MOV',
  '.mov',
  '.WMV',
  '.wmv',
  '.AVI',
  '.avi',
];
const List<String> audioExtensions = [
  '.MP3',
  '.mp3',
  '.WMA',
  '.wma',
  '.ASF',
  '.asf',
  '.3GP',
  '.3gp',
  '.3G2',
  '.3g2',
  '.AAC',
  '.aac',
  '.WAV',
  '.wav',
];
