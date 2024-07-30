import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SnackbarState { success, error, inValid }

void snackBarMessage(
    {required BuildContext context,
    required String message,
    required SnackbarState snackbarState,
    required Duration duration,
      bool inHome=false,
      bool displayBottom=true
    }) {
  FocusManager.instance.primaryFocus?.unfocus();
  final snackbar = SnackBar(
    backgroundColor: snackbarState == SnackbarState.error
        ? Colors.red
        : snackbarState == SnackbarState.success
            ? Colors.green
            : Colors.blue,
    content: Text(
      message,
      style:
          Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white),
      textAlign: TextAlign.center,

    ),
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(
      bottom: displayBottom?10.h:
      inHome?
      MediaQuery.of(context).size.height-150.h:MediaQuery.of(context).size.height-105.h,
      left: 8.w,
      right: 8.w,
    ),
    duration: duration,
  );
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
