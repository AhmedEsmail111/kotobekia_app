import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:kotobekia/shared/styles/colors.dart';
import 'package:solar_icons/solar_icons.dart';

class BuildSearchTextFormField extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback ?onTap;
  final bool readOnly;
  final String hintText;
  final FocusNode ?focusNode;
  final void Function(String?) ?onChange;
  const BuildSearchTextFormField({super.key,
     this.onTap,
     this.onChange,
     required this.hintText,
     this.readOnly=false,
    required this.searchController,
     this.focusNode
  });
  @override
  Widget build(BuildContext context) {
    var font =Theme.of(context).textTheme;
    return SizedBox(
      width: 279.w,
      height: 34.h,
      child: TextFormField(
        focusNode:focusNode ,
        readOnly:readOnly ,
        onChanged: onChange,
        textInputAction: TextInputAction.none,
        controller: searchController,
        onTap: onTap,
        maxLength: 40,
        cursorHeight: 18.h,
        style: font.titleMedium,
        decoration: InputDecoration(
          hintStyle:
          font.displayMedium!.copyWith(fontSize: 14.sp),
          contentPadding: EdgeInsets.symmetric(
              vertical: 6.h, horizontal: 10.w),
          counterText: '',
          prefixIcon:  Icon(
            SolarIconsOutline.magnifier,
            size: 14.w,
            color: Theme.of(context).iconTheme.color,
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide:  const BorderSide(color: ColorConstant.blackColor)
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color(
                    0xFFC8C5C5)), // Set the border color
            borderRadius: BorderRadius.circular(12.r),
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
