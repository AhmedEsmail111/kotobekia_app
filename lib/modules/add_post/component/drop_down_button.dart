import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/shared/styles/colors.dart';
import 'package:solar_icons/solar_icons.dart';

class BuildDropDownButton extends StatelessWidget {
  final String dropDownHint;
  final String errorMessage;
  final List<String> items;
  final String? value;
  final String text;
  final bool optional;
  final IconData? icon;

  final void Function(String? value)? onSelect;
  final void Function(String? value)? onSave;
  const BuildDropDownButton({
    super.key,
    required this.dropDownHint,
    required this.items,
    required this.text,
    this.onSelect,
    this.onSave,
    required this.errorMessage,
    this.icon,
    this.value,
    this.optional = false,
  });
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 16.h,
        ),
        Row(
          children: [
            if (icon == null)
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
        ),
        SizedBox(
          height: 4.h,
        ),
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: DropdownButtonFormField(
            value: value,
            menuMaxHeight: 300.h,
            icon: Icon(
              SolarIconsOutline.altArrowDown,
              size: 16.h,
              color: Theme.of(context).iconTheme.color,
            ),
            decoration: InputDecoration(
              fillColor: Theme.of(context).cardColor,
              filled: true,
              hintText: dropDownHint,
              hintStyle: const TextStyle().copyWith(color: Theme.of(context).highlightColor),
              border: InputBorder.none,
              errorStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.red,
                  ),
              prefixIcon: icon != null
                  ? Icon(
                      icon,
                      size: 16.h,
                      color: Theme.of(context).iconTheme.color,
                    )
                  : null,
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Container(
                  height: 45.h,
                  alignment: Alignment.topCenter,
                  child: RichText(
                    text: TextSpan(
                      text: item,
                      style: DefaultTextStyle.of(context).style,
                    ),
                  ),
                ),
              );
            }).toList(),
            onChanged: onSelect,
            onSaved: onSave,
            validator: optional == false
                ? (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return errorMessage;
                    }
                    return null;
                  }
                : null,
          ),
        ),
      ],
    );
  }
}
