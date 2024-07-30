import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../styles/colors.dart';

//Button for authentication services have icon and text

class BuildButtonAuthServices extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Color buttonColor;
  final String iconImage;
  final double elevation;
  final BuildContext context;


  const BuildButtonAuthServices({super.key,
    required this.onTap,
    required this.text,
    required this.buttonColor,
    required this.iconImage,
    required this.elevation,
    required this.context});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 17.5,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: buttonColor,
        ),
        onPressed: onTap,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Row(
            children: [
              Image.asset(iconImage,width: 28.w,height: 28.w,),
              SizedBox(
                width: MediaQuery.of(context).size.width / 22,
              ),
              Text(
                text,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: ColorConstant.blackColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


