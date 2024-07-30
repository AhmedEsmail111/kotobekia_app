import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/shared/component/handle_time.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../shared/styles/colors.dart';

class BuildUsersChat extends StatelessWidget {
  final String image;
  final TextTheme font;
  final String name;
  final String id;
  final String lastMessage;
  final String lastTimeMessage;
  final int numberOfUnreadMessage;
  final bool online;
  const BuildUsersChat(
      {super.key,
      required this.name,
      required this.online,
      required this.id,
      required this.numberOfUnreadMessage,
      required this.lastMessage,
      required this.lastTimeMessage,
      required this.font,
      required this.image});

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    String ?formattedDate;
    if(lastTimeMessage!=''){
      formattedDate=getTimeDifference(
          (DateTime.parse(lastTimeMessage)),locale);

    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Image.asset(
              image,
              height: 47.w,
              width: 47.w,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 2.h, left: 2.w),
              child: CircleAvatar(
                radius: 5.r,
                backgroundColor:online? ColorConstant.primaryColor:
                Colors.grey,
              ),
            )
          ],
        ),
        SizedBox(
          width: 16.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: font.bodyLarge!
                      .copyWith(fontSize: 14.sp, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(
              width: 165.w,
              child: Text(lastMessage,
                  overflow: TextOverflow.ellipsis,
                  style: font.displayMedium!.copyWith(
                      fontSize: 12.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        const Spacer(),
        Column(
          children: [
            Text(
              lastTimeMessage==''?'':formattedDate!,
              style: font.titleSmall!.copyWith(fontSize: 11.sp,color: Theme.of(context).hoverColor),
            ),
            SizedBox(height: 5.h,),
            if(numberOfUnreadMessage!=0)
              CircleAvatar(
                radius: 12.w,
                backgroundColor: ColorConstant.primaryColor,
                child: Text(numberOfUnreadMessage.toString(),
              style: font.displayMedium!.copyWith(fontSize: 10.h),),)
          ],
        )
      ],
    );
  }
}
