import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/colors.dart';

// Default Button in my app

class BuildDefaultButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final Color color;
  final double elevation;
  final BuildContext context;
  final bool withBorder;

  const BuildDefaultButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.color,
    required this.elevation,
    required this.context,
    this.withBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          shape: RoundedRectangleBorder(
            side: withBorder
                ? const BorderSide(color: ColorConstant.primaryColor)
                : BorderSide.none,
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: color,
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color:
                    withBorder ? Theme.of(context).shadowColor : ColorConstant.foregroundColor,
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.width / 22.5,
              ),
        ),
      ),
    );
  }
}
