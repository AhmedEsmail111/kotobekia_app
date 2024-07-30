import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

ThemeData lightTheme({required double width, required double height}) =>
    ThemeData(
      brightness: Brightness.light,
      cardColor: ColorConstant.whiteColor,
      dividerColor:ColorConstant.lightDividerColor,
      hoverColor: Colors.black54,
      highlightColor: Colors.black26,
      focusColor: ColorConstant.midGrayColor,
      shadowColor: Colors.black,
      primaryColor:ColorConstant.blackColor,
      buttonTheme: const ButtonThemeData(
        buttonColor: ColorConstant.primaryColor
      ),
      iconTheme: const IconThemeData(
        color: ColorConstant.iconsColor
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedLabelStyle:
        TextStyle(
            fontFamily: 'NotoSansArabic-SemiBold',
            color: ColorConstant.primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 11.sp),
        unselectedLabelStyle:
        TextStyle(
            fontFamily: 'NotoSansArabic-SemiBold',
            fontWeight: FontWeight.w700,
            fontSize: 11.sp),
        selectedItemColor: ColorConstant.primaryColor,
        selectedIconTheme: const IconThemeData(
          color: ColorConstant.primaryColor
        ),
        unselectedIconTheme:const IconThemeData(
          color: ColorConstant.iconColor
        ),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black,
        backgroundColor: ColorConstant.whiteColor,

      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
            fontFamily: 'NotoSansArabic-SemiBold',
            fontSize: width / 28,
            color: ColorConstant.primaryColor,
            fontWeight: FontWeight.w800),
        bodyLarge: TextStyle(
            fontFamily: 'NotoSansArabic-SemiBold',
            fontSize: width / 20,
            fontWeight: FontWeight.w900),
        bodyMedium: TextStyle(
          fontFamily: 'NotoSansArabic-Regular',
          fontSize: width / 25,
        ),
        titleMedium: TextStyle(
            fontFamily: 'NotoSansArabic-Medium',
            fontSize: width / 22.8,
            fontWeight: FontWeight.w500),
        displayMedium: TextStyle(
          fontFamily: 'NotoSansArabic-Regular',
          fontSize: width / 22.8,
        ),
        titleLarge: TextStyle(
            fontFamily: 'NotoSansArabic-Regular',
            fontSize: width / 12.5,
            color: ColorConstant.primaryColor,
            fontWeight: FontWeight.bold),
      ),
      scaffoldBackgroundColor: ColorConstant.backgroundColor,
      appBarTheme: AppBarTheme(
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: ColorConstant.scaffoldBackgroundColor,
              statusBarIconBrightness: Brightness.dark
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(
            color: ColorConstant.iconColor,
            size: width / 18,
          )),
    );



// ThemeData darkTheme({required double width, required double height}) =>
//     ThemeData(
//       buttonTheme: ButtonThemeData(
//           buttonColor: ColorConstant.cardColor
//       ),
//       brightness: Brightness.dark,
//       focusColor: Colors.grey,
//       hoverColor: Colors.white,
//       highlightColor: Colors.grey,
//       primaryColor:ColorConstant.whiteColor,
//       cardColor: ColorConstant.cardColor,
//       dividerColor:ColorConstant.darkDividerColor,
//       shadowColor: Colors.white,
//       iconTheme: const IconThemeData(
//           color: ColorConstant.whiteColor
//       ),
//       textTheme: TextTheme(
//         displayLarge: TextStyle(
//             fontFamily: 'NotoSansArabic-SemiBold',
//             fontSize: width / 28,
//             color: ColorConstant.primaryColor,
//             fontWeight: FontWeight.w800),
//         bodyLarge: TextStyle(
//             fontFamily: 'NotoSansArabic-SemiBold',
//             fontSize: width / 20,
//             color: Colors.white,
//             fontWeight: FontWeight.w900),
//         bodyMedium: TextStyle(
//           fontFamily: 'NotoSansArabic-Regular',
//           color: Colors.white,
//           fontSize: width / 25,
//         ),
//         titleMedium: TextStyle(
//             fontFamily: 'NotoSansArabic-Medium',
//             fontSize: width / 22.8,
//             color: Colors.white,
//             fontWeight: FontWeight.w500),
//         displayMedium: TextStyle(
//           fontFamily: 'NotoSansArabic-Regular',
//           color: Colors.white,
//           fontSize: width / 22.8,
//         ),
//         titleLarge: TextStyle(
//             fontFamily: 'NotoSansArabic-Regular',
//             fontSize: width / 12.5,
//             color: ColorConstant.primaryColor,
//             fontWeight: FontWeight.bold),
//       ),
//       scaffoldBackgroundColor: ColorConstant.darkScaffoldBackgroundColor,
//       appBarTheme: AppBarTheme(
//
//           systemOverlayStyle: const SystemUiOverlayStyle(
//               statusBarColor: ColorConstant.darkScaffoldBackgroundColor,
//               statusBarIconBrightness: Brightness.light),
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           scrolledUnderElevation: 0,
//           iconTheme: IconThemeData(
//             color: ColorConstant.iconColor,
//             size: width / 18,
//           )),
//       bottomNavigationBarTheme: BottomNavigationBarThemeData(
//         selectedLabelStyle:
//         TextStyle(
//             fontFamily: 'NotoSansArabic-SemiBold',
//             color: ColorConstant.primaryColor,
//             fontWeight: FontWeight.w700,
//
//             fontSize: 11.sp),
//         unselectedLabelStyle:
//         TextStyle(
//             fontFamily: 'NotoSansArabic-SemiBold',
//             fontWeight: FontWeight.w700,
//             fontSize: 11.sp),
//         selectedItemColor: ColorConstant.primaryColor,
//         selectedIconTheme: const IconThemeData(
//             color: ColorConstant.primaryColor
//         ),
//         unselectedIconTheme:const IconThemeData(
//             color: ColorConstant.whiteColor
//         ),
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: ColorConstant.cardColor,
//         unselectedItemColor: Colors.white,
//       ),
//     );



