import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';

import '../styles/colors.dart';

class BuildRowTextSecurity extends StatelessWidget {
  final String text;
  final bool withIcon;
  final withCircleAvatar;

  const BuildRowTextSecurity(
      {super.key,
      required this.text,
      required this.withIcon,
      this.withCircleAvatar});

  @override
  Widget build(BuildContext context) {
    TextTheme font = Theme.of(context).textTheme;
    double w = MediaQuery.sizeOf(context).width;
    return Row(
      children: [
        if (withCircleAvatar)
          const CircleAvatar(
            radius: 2.5,
            backgroundColor: ColorConstant.primaryColor,
          ),
        SizedBox(
          width: w / 65,
        ),
        Flexible(
          child: Text(
            text,
            style: font.titleMedium!.copyWith(fontSize: w / 39),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        SizedBox(
          width: 4.w,
        ),
        if (withIcon)
          Icon(
            SolarIconsOutline.shieldUser,
            color: ColorConstant.primaryColor,
            size: 15.w,
          )
      ],
    );
  }
}
