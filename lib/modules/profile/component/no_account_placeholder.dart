import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/shared/styles/colors.dart';

class NoAccountPlaceholder extends StatelessWidget {
  const NoAccountPlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Column(
      children: [
        SizedBox(
          height: 24.h,
        ),
        Row(
          children: [
            Text(
              locale.have_no_profile_message,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.w500,fontSize: 14.sp),
            ),
            SizedBox(
              width: 4.w,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'createAccount');
              },
              child: Text(
                locale.register,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: ColorConstant.primaryColor,
                      decoration: TextDecoration.underline,
                    ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8.h,
        ),
        Row(
          children: [
            Text(
              locale.have_account,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: 4.w,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'login');
              },
              child: Text(
                locale.login,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: ColorConstant.primaryColor,
                      decoration: TextDecoration.underline,
                    ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 24.h,
        ),
      ],
    );
  }
}
