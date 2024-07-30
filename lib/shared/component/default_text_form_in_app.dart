import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/authentication/authentication_cubit.dart';
import 'package:solar_icons/solar_icons.dart';

import '../styles/colors.dart';

// Default TextFormField in my app

class BuildDefaultTextField extends StatelessWidget {
  final TextInputType inputType;
  final void Function(String? value)? onSaved;
  final String? Function(String? value)? onValidate;
  final String hintText;
  final bool isObscured;
  final String? aboveFieldText;
  final BuildContext context;
  final bool withText;
  final double width;
  final double height;
  final TextEditingController? controller;
  final int maxLenght;
  final Color backGroundColor;
  final Icon? prefixIcons;
  final AuthenticationCubit? cubit;
  final int? numberOfFormPass;
  final int? maxLines;
  final void Function(String)? onChange;
  final bool withEyeVisible;
  final bool? isEnabled;
  const BuildDefaultTextField({
    super.key,
    this.cubit,
    this.numberOfFormPass,
    this.withEyeVisible = false,
    required this.inputType,
    required this.withText,
    required this.hintText,
    this.aboveFieldText,
    this.prefixIcons,
    required this.backGroundColor,
    required this.context,
    required this.width,
    required this.height,
    required this.maxLenght,
    this.controller,
    this.onSaved,
    this.onValidate,
    required this.isObscured,
    this.onChange,
    this.isEnabled,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (withText == true)
          Text(
            aboveFieldText!,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: MediaQuery.of(context).size.width / 25.5,
            ),
            textAlign: TextAlign.left,
          ),
        SizedBox(height: 5.h,),
        Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
              width: width,
              decoration: BoxDecoration(
                  color: ColorConstant.backgroundColor,
                  borderRadius: BorderRadius.circular(14.r)),
              child: TextFormField(
                  enabled: isEnabled,
                  onChanged: onChange,
                  maxLength: maxLenght,
                  maxLines: maxLines ?? 1,
                  controller: controller,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: ColorConstant.blackColor,
                    fontWeight: FontWeight.w300,
                  ),
                  obscureText: isObscured
                      ? (numberOfFormPass == 1
                      ? cubit!.isObscureOne
                      : cubit!.isObscureTwo)
                      : isObscured,
                  keyboardType: inputType,
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    counterText: '',
                    errorStyle: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.red),
                    filled: true,
                    fillColor: backGroundColor,
                    hintText: hintText,
                    hintStyle:
                    const TextStyle().copyWith(color: Colors.black26),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: BorderSide.none),
                    prefixIcon: prefixIcons,
                    suffixIcon: withEyeVisible
                        ? GestureDetector(
                      onTap: () {
                        cubit?.changeVisiabilityPassword(
                            numberOfFormPass!);
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width / 20,
                          padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width / 40,
                          ),
                          alignment: Alignment.centerRight,
                          child: (numberOfFormPass == 1
                              ? cubit!.isObscureOne
                              : cubit!.isObscureTwo)
                              ? const Icon(SolarIconsOutline.eyeClosed)
                              : const Icon(SolarIconsOutline.eye)),
                    )
                        : null,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 25,
                      vertical: MediaQuery.of(context).size.width / 50,
                    ),
                  ),
                  onSaved: (newValue) {
// you have to check if the newValue is not null before doing any work with it
                    onSaved!(newValue!);
                  },
// you have to check if the newValue is not null before doing any work with it
                  validator: onValidate)),
        ),
      ],
    );
  }
}