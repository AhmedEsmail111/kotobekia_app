import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:kotobekia/shared/network/local/local.dart';

class AppConstant {
  static TextDirection directionalityApp = TextDirection.rtl;
  static const String token = 'token';
  static const String otpScreen = 'otp';
  static const String reciveId = 'reciveId';
  static const String convId = 'convId';
  static const String city = 'city';
  static const languageKey = 'userLanguage';
  static const emailOrPhone = 'emailOrPhone';
  static const mode = 'mode';
  static const tokenDevice = 'tokenDevice';
  static const changePassword = 'changePassword';
  static const baseShareUrl = 'https://api.kotobekia.cloud';
  static const userId = 'userId';
  static const imageUrl = 'https://api.kotobekia.cloud/';
  static const String socketURL = "https://api.kotobekia.cloud";
  static String lang=CacheHelper.getData(key: AppConstant.languageKey);

}
