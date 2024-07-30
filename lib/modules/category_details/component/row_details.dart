import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildRowDetails extends StatelessWidget {
  final bool isLast;
  final String firstText;
  final String secondText;

  const BuildRowDetails({
    super.key,
    required this.firstText,
    required this.secondText,
    required this.isLast,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5.h,),
        Row(
          children: [
            Text(
              firstText,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: const Color(0xFF939393),
                  fontSize: 12.sp,fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Text(
              secondText,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 12.sp),
            ),
          ],
        ),
        SizedBox(height: 5.h,),
        if (isLast)
          const Divider(
            thickness: 1.5,
          )
        ,


      ],
    );
  }
}
