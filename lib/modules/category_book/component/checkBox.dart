import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/shared/styles/colors.dart';

class BuildCheckBox extends StatelessWidget {
  const BuildCheckBox({super.key,required this.text,
  required this.value,
  required this.onChanged,
  });
  final String text;
  final bool value;
  final void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    final font=Theme.of(context).textTheme;
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      spacing:5.w,
      runAlignment:WrapAlignment.center,
      runSpacing: 5.w,
      crossAxisAlignment: WrapCrossAlignment.center,
      textDirection: TextDirection.rtl,
      verticalDirection: VerticalDirection.up,
        children: [
      Checkbox
        (
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.r),
          ),
          side: const BorderSide(color: ColorConstant.extraGreyColor),
          value: value,
          activeColor: ColorConstant.primaryColor,
          onChanged:onChanged),
      Text(text,style: font.titleMedium,),
    ]);
  }
}
