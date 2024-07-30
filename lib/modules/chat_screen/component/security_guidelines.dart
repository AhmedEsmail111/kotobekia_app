import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kotobekia/shared/component/row_in_securiy_rules.dart';
import 'package:solar_icons/solar_icons.dart';

import '../../../shared/styles/colors.dart';

class BuildSecurityGuideLines extends StatelessWidget {
  final double w;
  final double h;
  final TextTheme font;

  const BuildSecurityGuideLines(
      {super.key, required this.h, required this.w, required this.font});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.only(bottom: h / 60),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(w / 30),
      ),
      child: Padding(
        padding: EdgeInsets.all(w / 80),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  SolarIconsOutline.shieldCheck,
                  color: ColorConstant.primaryColor,
                  size: h / 40,
                ),
                SizedBox(
                  width: w / 65,
                ),
                Text(
                  locale!.your_security,
                  style: font.titleMedium,
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: w / 30, top: w / 80),
              child: Column(
                children: [
                  BuildRowTextSecurity(
                    withCircleAvatar: true,
                    withIcon: false,
                    text: locale.abuse_advice1,
                  ),
                  BuildRowTextSecurity(
                    withIcon: true,
                    text: locale.abuse_advice2,
                    withCircleAvatar: true,
                  ),
                  BuildRowTextSecurity(
                    withIcon: false,
                    text: locale.abuse_advice3,
                    withCircleAvatar: false,
                  ),
                  BuildRowTextSecurity(
                    withIcon: false,
                    text: locale.abuse_advice4,
                    withCircleAvatar: true,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
