import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/shared/styles/colors.dart';

class BuildAddsSection extends StatelessWidget {
  final String imageUrl;
  const BuildAddsSection({
    super.key,
    required this.imageUrl,
  });
  @override
  Widget build(BuildContext context) {

    return Container(
      height: 115.h,
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Stack(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Image.network(
            height: 115.h,
            imageUrl,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
            left: 10,
            top: 10,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: ColorConstant.whiteColor,
              ),
              width: 25.h,
              height: 25.h,
              child: Text(
                'AD',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 12.sp,
                      color: const Color(0xFF0F172A),
                    ),
              ),
            ))
      ]),
    );
  }
}
