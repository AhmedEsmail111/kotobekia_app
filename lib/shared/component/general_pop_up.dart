import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showPopUp({required BuildContext context,
  required String textTitle,
  required String textOk,
  required String textCenter,
  required VoidCallback onPress
}){
  var font=Theme.of(context).textTheme;
  final locale = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title:  Text(
          textTitle,
          style: font.bodyLarge,
        ),
        content: Text(
          textCenter,

        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pop();
            },
            child: Text(
              locale.cancel,
              style: font.displayLarge!.copyWith(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: onPress,
            child: Text(
              textOk,
              style: font.displayLarge!.copyWith(color:Colors.blueAccent),
            ),
          ),
        ],
      );
    },
  );

}