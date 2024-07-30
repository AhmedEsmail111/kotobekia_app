import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/otp/otp_cubit.dart';
import 'package:kotobekia/modules/create_account/create_account_screen.dart';
import 'package:kotobekia/modules/otp/otp_screen.dart';
import 'package:kotobekia/shared/component/default_button_in_app.dart';
import 'package:kotobekia/shared/component/default_text_form_in_app.dart';
import 'package:kotobekia/shared/component/back_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kotobekia/shared/component/navigation.dart';
import 'package:kotobekia/shared/component/snakbar_message.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';

import 'package:kotobekia/shared/styles/colors.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme font = Theme
        .of(context)
        .textTheme;
    var emailOrPhoneController = TextEditingController();
    final locale = AppLocalizations.of(context);
    double w = MediaQuery
        .sizeOf(context)
        .width;
    double h = MediaQuery
        .sizeOf(context)
        .height;
    var formKey = GlobalKey<FormState>();
    String? _validateInput(String? value) {
      if (value == null || value.isEmpty) {
        return locale!.enterEmailOrPhone;
      }
      // Check if the input is a valid email
      if (RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
        return null;
      }
      // Check if the input is a valid phone number
      if (RegExp(r'^[0-9]{11}$').hasMatch(value.trim())) {
        return null;
      }
      return locale.enterValidEmailOrPhone;
    }
    var cubit = context.read<OtpCubit>();
    return BlocConsumer<OtpCubit, OtpState>(
      listener: (context, state) {
        if(state is FailedNoInternetConnectionOtpState){
          snackBarMessage(
              context: context,
              message: locale.no_internet,
              snackbarState: SnackbarState.error,
              duration: const Duration(seconds: 2));
        }
        if(state is SuccessResendOtpState){
          pushWithAnimationLeftAndBottom(context: context,
              widget:  OtpScreen(
                  forgetPass:true,
                  emailOrPhone: emailOrPhoneController.text));
          CacheHelper.saveData(key: AppConstant.otpScreen, value: true);
        }
        if(state is FailedResendOtpState){
          snackBarMessage(context: context,
              message:state.error,
              snackbarState:
              SnackbarState.error,
              duration: const Duration(seconds: 1));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: BuildBackIcon(onTap: () {
              Navigator.pop(context);
            }),
          ),
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(left: w / 20, right: w / 20),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      SizedBox(
                        height: 50.h,
                      ),
                      Text(
                        locale.enterEmailOrPhone,
                        style: font.titleMedium!.copyWith(fontSize: 18.sp),
                      ),
                      SizedBox(height: 10.h,),
                      Text(
                        locale.makeSurePhoneOrNumberForOtp,

                        style: font.displayMedium!.copyWith(fontSize: 14.sp,
                            height: 1.5),
                      ),
                      SizedBox(
                        height: 60.h,
                      ),
                      BuildDefaultTextField(
                          withEyeVisible: false,
                          backGroundColor: Colors.white,
                          maxLenght: 320,
                          controller: emailOrPhoneController,
                          width: double.infinity,
                          height: h / 16.8,
                          withText: true,
                          isObscured: false,
                          onValidate: _validateInput,
                          inputType: TextInputType.emailAddress,
                          hintText: locale.hintEmailOrPhone,
                          aboveFieldText: locale.hintEmailOrPhone,
                          context: context),
                      SizedBox(height: 50.h,),
                      state is LoadingResendOtpState?
                      const Center(child:  CircularProgressIndicator(color:ColorConstant.primaryColor,)):
                      BuildDefaultButton(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              cubit.sendCodeOtp(phone:
                              !isEmail(emailOrPhoneController.text)
                                  ? emailOrPhoneController.text
                                  : null,
                                email: isEmail(emailOrPhoneController.text)
                                    ? emailOrPhoneController.text
                                    : null,
                              );

                            }
                          },
                          text: locale.continue1,
                          color: ColorConstant.primaryColor,
                          elevation: 4,
                          context: context)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
