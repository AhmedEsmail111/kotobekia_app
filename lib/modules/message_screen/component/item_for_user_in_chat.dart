import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../shared/styles/colors.dart';

class BuildItemForUserInChat extends StatelessWidget {
  final TextTheme font;
  final String image;
  final String title;
  final String category;
  final String price;

  const BuildItemForUserInChat(
      {super.key,
      required this.font,
      required this.image,
      required this.price,
      required this.title,
      required this.category});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Image.network(
            image,
            height: 34.h,
            width: 34.h,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          width: 8.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 220.w,
                  child: Text(title,
                      overflow: TextOverflow.ellipsis,
                      style: font.bodyLarge!.copyWith(
                          fontSize: 12.sp, fontWeight: FontWeight.w500)),
                ),
                Container(
                  alignment: Alignment.center,
                padding: EdgeInsets.all(4.h),
                  decoration: BoxDecoration(
                      color: price == '0.0'
                          ? ColorConstant.primaryColor.withOpacity(0.2)
                          : const Color(0xFFD0E6F3),
                      borderRadius: BorderRadius.circular(
                          MediaQuery.sizeOf(context).width / 30)),
                  child: Text(
                    price == '0.0' ? locale.free : '$price ${locale.egp}',
                    style: font.titleLarge!.copyWith(
                      color: price =='0.0'
                          ? ColorConstant.primaryColor
                          : const Color(0xFF1077FB),
                        fontSize: MediaQuery.sizeOf(context).width / 38,
                        fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
            SizedBox(
                width: 220.w,
                child: Text(category,
                    overflow: TextOverflow.ellipsis,
                    style: font.bodyMedium!.copyWith(fontSize: 10.sp)))
          ],
        ),
      ],
    );
  }
}
