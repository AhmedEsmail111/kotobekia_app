import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildRowAboveOptions extends StatelessWidget {
  final String text;
  final bool optional;
  const BuildRowAboveOptions(
      {super.key, required this.text, this.optional = false});
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(
          width: 4.w,
        ),
        if (optional)
          Text(
            '(${locale.optional})',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
          ),
      ],
    );
  }
}
