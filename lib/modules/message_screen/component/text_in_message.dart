import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../shared/styles/colors.dart';

class BuildTextMessage extends StatelessWidget {
  final TextTheme font;
  final String text;
  final bool sender;
  final String date;
  const BuildTextMessage({super.key, required this.font,
    required this.text,required this.sender,required this.date});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    String formattedDate = DateFormat('EEEE, h:mm a').
    format(DateTime.parse(date));
    return Padding(
      padding: EdgeInsets.only(left: 15.w, right: 15.w),
      child: Align(
        alignment:sender
            ? AlignmentDirectional.centerStart
            : AlignmentDirectional.centerEnd,
        child: Column(
          crossAxisAlignment:sender? CrossAxisAlignment.start:CrossAxisAlignment.end,
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 10.h),
                decoration: BoxDecoration(
                    color: sender?ColorConstant.primaryColor:ColorConstant.foregroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                      bottomLeft:CacheHelper.getData(key: AppConstant.languageKey)=='ar'?
                          sender?Radius.circular(20.r):const Radius.circular(0):
                      sender?const Radius.circular(0): Radius.circular(20.r),
                      bottomRight:CacheHelper.getData(key: AppConstant.languageKey)=='ar'?
                    sender?const Radius.circular(0): Radius.circular(20.r):
                    sender? Radius.circular(20.r): const Radius.circular(0)
                    )),
                child: Text(
                  text.trim(),
                  style: font.titleMedium!.copyWith(fontSize: 12.sp,fontWeight: FontWeight.w500),
                )),
            Text(formattedDate,
              style: font.displayMedium!.copyWith(fontSize: 8.
              sp,color: Colors.grey,fontWeight: FontWeight.w700),)
          ],
        ),
      ),
    );
  }
}
