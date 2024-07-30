import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/shared/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BuildNoInternet extends StatelessWidget {
  const BuildNoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    var font =Theme.of(context).textTheme;
    final locale = AppLocalizations.of(context);

    return  Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.wifi_slash,color: ColorConstant.dangerColor,size: 60.w,),
            SizedBox(height: 20.h,),
            Text(locale.opps,style: font.bodyLarge,),
            SizedBox(height: 10.h,),
            Text(locale.no_internet,),
            SizedBox(height: 15.h,),
          ],),
      ),
    );
  }
}
