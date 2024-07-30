import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void buildDialogue({required BuildContext context,
  required String message}) {
  final locale = AppLocalizations.of(context);

  final dialogue = AlertDialog(
    title: Center(
      child: Text(
        message,
        style:
            Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.sp),
        textAlign: TextAlign.center,
      ),
    ),
    actions: [
      TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(locale!.ok))
    ],
    actionsAlignment: MainAxisAlignment.center,
  );

  showDialog(
    context: context,
    builder: (context) {
      return dialogue;
    },
  );
}
