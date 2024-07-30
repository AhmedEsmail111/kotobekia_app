import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/shared/styles/colors.dart';

class BuildProfileTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final bool withSwitchIcon;
  final void Function()? onClick;
  final void Function(bool status)? onSwitchToggled;
  final bool? switchStatus;

  const BuildProfileTile({
    super.key,
    required this.icon,
    required this.text,
    required this.withSwitchIcon,
    required this.onClick,
    required this.iconColor,
    this.onSwitchToggled,
    this.switchStatus,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      horizontalTitleGap: 8.w,
      onTap: onClick,
      leading: Icon(icon, color: iconColor),
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 14.sp,
              color: iconColor == ColorConstant.dangerColor
                  ? ColorConstant.dangerColor
                  : null,
            ),
      ),
      trailing: withSwitchIcon
          ? Switch(
              value: switchStatus!,
              onChanged: withSwitchIcon ? onSwitchToggled : null,
              activeTrackColor: ColorConstant.secondaryColor,
              inactiveTrackColor: ColorConstant.midGrayColor,
            )
          : null,
    );
  }
}
