import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildRowAboveCard extends StatelessWidget {
  const BuildRowAboveCard({
    super.key,
    required this.title,
    required this.isEmptySeeMore,
    required this.numberOfBooks,
    required this.onTap,
  });

  final String title;
  final int numberOfBooks;
  final bool isEmptySeeMore;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 4.h, left: 16.w, right: 16.w, top: 6.h),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700),
          ),
          Text(
            '$numberOfBooks+',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
          ),
          const Spacer(),
          if(isEmptySeeMore)
            GestureDetector(
            onTap: onTap,
            child: Text(
              locale!.show_more,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                  decorationColor: const Color(0xFF475569)),
            ),
          ),
        ],
      ),
    );
  }
}
