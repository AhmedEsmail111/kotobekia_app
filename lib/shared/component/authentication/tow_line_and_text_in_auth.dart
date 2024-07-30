import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../styles/colors.dart';

//Default Row in Authentication Screens

class BuildTowLineRowInAuth extends StatelessWidget {
  final BuildContext context;
  const BuildTowLineRowInAuth({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height / 390,
          width: MediaQuery.sizeOf(context).width / 2.85,
          color: ColorConstant.strieghtLineColor.withOpacity(0.5),
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width / 13.5,
        ),
        Text(
          AppLocalizations.of(context)!.or,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: MediaQuery.sizeOf(context).width / 20.5,
              color: ColorConstant.strieghtLineColor),
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width / 13.5,
        ),
        Container(
          height: MediaQuery.sizeOf(context).height / 390,
          width: MediaQuery.sizeOf(context).width / 2.85,
          color: ColorConstant.strieghtLineColor.withOpacity(0.5),
        ),
      ],
    );
  }
}
