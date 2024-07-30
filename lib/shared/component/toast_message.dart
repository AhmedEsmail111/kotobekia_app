import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kotobekia/shared/styles/colors.dart';

void buildToastMessage(
    {required String message, required ToastGravity gravity}) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: 2,
      backgroundColor: ColorConstant.lightGreyColor,
      textColor: ColorConstant.blackColor,
      fontSize: 16.sp);
}
