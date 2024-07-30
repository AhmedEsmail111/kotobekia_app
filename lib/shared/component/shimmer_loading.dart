import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  const Skeleton({super.key,
    this.border = 15,
    required this.height,required this.width});

  final double? height, width,border;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: Colors.blue[100]!,
      child: Container(
        height: height,
        width: width,
        padding:  EdgeInsets.all(8.h),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.04),
            borderRadius:
            BorderRadius.all(Radius.circular(border!))),
      ),
    );
  }
}

class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({super.key, this.size = 24});

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: Colors.blue[100]!,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.04),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}


class BuildBookShimmer extends StatelessWidget {
  const BuildBookShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: Colors.blue[100]!,
      child: SizedBox(
        width: 130.w,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Skeleton(
                height: 144.h,
                width: 150.w),
            SizedBox(
              height: 5.h,
            ),
            Skeleton(
                height: 15.h,
                width: 100.w),
            SizedBox(
              height: 7.h,
            ),
            Skeleton(
                height: 10.h,
                width: 120.w),
            SizedBox(
              height: 7.h,
            ),
            Row(
              children: [
                CircleSkeleton(
                  size: 12.r,
                ),
                SizedBox(
                  width: 8.w,
                ),
                CircleSkeleton(
                  size: 12.r,
                ),
                const Spacer(),
                Skeleton(
                    height: 22.h,
                    width: 50.w),
              ],
            ),
            SizedBox(
              height: 8.h,
            ),
            Skeleton(
                height: 8.h, width: 30.w),
            SizedBox(
              height: 5.h,
            ),
            Row(
              children: [
                Skeleton(
                    height: 8.h,
                    width: 40.w),
                const Spacer(),
                Skeleton(
                    height: 8.h,
                    width: 50.w),
              ],
            )
          ],
        ),
      ),
    );
  }
}
