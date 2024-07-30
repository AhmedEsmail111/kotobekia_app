import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';

class HelperFunctions {
  static bool isArabic(String text) {
    for (int i = 0; i < text.length; i++) {
      int charCode = text.codeUnitAt(i);

      // Check if the character is in the Arabic script range
      if (charCode >= 0x0600 && charCode <= 0x06FF) {
        return true;
      }
    }

    return false;
  }

  static Future<String> detectImageFormat(File imageFile) async {
    final List<int> bytes = await imageFile.readAsBytes();

    if (isJpeg(bytes)) {
      return 'jpeg';
    } else if (isPng(bytes)) {
      return 'png';
    }

    // Default to 'jpeg' if the format is not recognized
    return 'jpeg';
  }

  static bool isJpeg(List<int> bytes) {
    // JPEG files start with the signature FF D8 FF
    return bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF;
  }

  static bool isPng(List<int> bytes) {
    // PNG files start with the signature 89 50 4E 47 0D 0A 1A 0A
    return bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0D &&
        bytes[5] == 0x0A &&
        bytes[6] == 0x1A &&
        bytes[7] == 0x0A;
  }

  static Future<bool> hasConnection() async {
    var isDeviceConnected = await InternetConnectionChecker().hasConnection;
    var connectionResult = await Connectivity().checkConnectivity();
    if (connectionResult == ConnectivityResult.mobile ||
        connectionResult == ConnectivityResult.wifi) {
      isDeviceConnected = true;
    } else {
      isDeviceConnected = false;
    }
    return isDeviceConnected;
  }

  static bool hasUserRegistered() {
    final token = CacheHelper.getData(key: AppConstant.token);

    return token != null;
  }

}
