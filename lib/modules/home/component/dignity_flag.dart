import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/shared/constants/images/images_constant.dart';

class BuildPalestine extends StatelessWidget {
  final String text;

  const BuildPalestine({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 30.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.w),
      color: Theme.of(context).dividerColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              text,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
          Image.asset(
            ImageConstant.palestineMapImage,
            width: 20,
            height: 20,
            fit: BoxFit.cover,
          ),
          Image.asset(
            ImageConstant.palestineImage,
            width: 20,
            height: 20,
            fit: BoxFit.cover,
          )
        ],
      ),
    );
  }
}
