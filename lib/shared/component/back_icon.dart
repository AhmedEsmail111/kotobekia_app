import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:kotobekia/shared/styles/colors.dart';

class BuildBackIcon extends StatelessWidget {
  final VoidCallback onTap;
  final bool backX;
  const BuildBackIcon({super.key,
    required this.onTap,
     this.backX=false,

  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
          padding: EdgeInsets.only(
              right: CacheHelper.getData(key: AppConstant.languageKey) == 'ar'
                  ? 16.w
                  : 0,
              left: CacheHelper.getData(key: AppConstant.languageKey) != 'ar'
              ? 16.w
              : 0,top: 10.h,bottom: 6.h),
      child: Container(
        width: 34.w,
        height: 34.w,
        decoration: BoxDecoration(
            color: Theme.of(context).focusColor,
            borderRadius: BorderRadius.circular(backX?18.r:8.r)),
        child:  Icon(backX?Icons.close:
        Icons.arrow_back_ios_new,
          color: Theme.of(context).hoverColor,
        ),
      ),
    ),);
  }
}
