import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/otp/otp_cubit.dart';

import '../../styles/colors.dart';

//Row is in Authentication Screen

class BuildRowTextAndLink extends StatelessWidget {
  final String text;
  final String textLink;
  final BuildContext context;
  final VoidCallback onTap;
  final double fontSize;
  final OtpCubit? cubit;

  const BuildRowTextAndLink(
      {super.key,
      required this.text,
      this.cubit,
      required this.fontSize,
      required this.textLink,
      required this.context,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(
          width: MediaQuery.sizeOf(context).width / 100,
        ),
        cubit != null
            ? (cubit!.enableResend
                ? GestureDetector(
                    onTap: onTap,
                    child: Text(
                      textLink,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: fontSize,
                            color: ColorConstant.primaryColor,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  )
                : Row(
                    children: [
                      Text(
                        'ارسل بعد ',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(fontSize: 15.sp),
                      ),
                      Text(
                        '${cubit!.secondsRemaining}',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontSize: 15.sp),
                      ),
                      Text(
                        ' ثانيه',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(fontSize: 15.sp),
                      ),
                    ],
                  ))
            : GestureDetector(
                onTap: onTap,
                child: Text(
                  textLink,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: fontSize,
                        color: ColorConstant.primaryColor,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                ),
              )
      ],
    );
  }
}
