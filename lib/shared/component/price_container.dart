import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/shared/styles/colors.dart';

class BuildPriceContainer extends StatelessWidget {
  final dynamic price;
  final AppLocalizations locale;
  const BuildPriceContainer(
      {super.key, required this.price, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      alignment: Alignment.center,
      height: 25.h,
      decoration: BoxDecoration(
        color: price == 0 ||price == "0.0"
            ? ColorConstant.primaryColor.withOpacity(0.2)
            : const Color(0xFFD0E6F3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        price == 0||price == "0.0"  ? locale.free : '$price ${locale.egp}',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              // textBaseline: TextBaseline.alphabetic,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: price == 0||price =="0.0"
                  ? ColorConstant.primaryColor
                  : const Color(0xFF1077FB),
            ),
      ),
    );
  }
}
