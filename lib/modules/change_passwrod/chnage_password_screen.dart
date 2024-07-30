import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/authentication/authentication_cubit.dart';
import 'package:kotobekia/controller/home/home_cubit.dart';
import 'package:kotobekia/controller/otp/otp_cubit.dart';
import 'package:kotobekia/controller/profile/profile_cubit.dart';
import 'package:kotobekia/modules/create_account/create_account_screen.dart';
import 'package:kotobekia/modules/otp/otp_screen.dart';
import 'package:kotobekia/shared/component/default_button_in_app.dart';
import 'package:kotobekia/shared/component/default_text_form_in_app.dart';
import 'package:kotobekia/shared/component/back_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kotobekia/shared/component/general_pop_up.dart';
import 'package:kotobekia/shared/component/snakbar_message.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:kotobekia/shared/styles/colors.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key,
    this.emailOrPhone,
    this.forgetPassword = false,
  });

  final bool forgetPassword;
  final String ?emailOrPhone;

  @override
  Widget build(BuildContext context) {
    TextTheme font = Theme
        .of(context)
        .textTheme;
    final locale = AppLocalizations.of(context);
    double w = MediaQuery
        .sizeOf(context)
        .width;
    double h = MediaQuery
        .sizeOf(context)
        .height;
    var formKey = GlobalKey<FormState>();
    var currentPasswordController = TextEditingController();
    var newPasswordController = TextEditingController();
    var confirmNewPasswordController = TextEditingController();
    String ?token = CacheHelper.getData(key: AppConstant.token);

    return WillPopScope(
      onWillPop: () async {
        if (forgetPassword) {
          showPopUp(
            context: context,
            textTitle: locale.areYouSure,
            textOk: locale.ok,
            textCenter: '',
            onPress: () {
              Navigator.pushReplacementNamed(context, 'homeLayout');
            },
          );
        }else{
          if(!ModalRoute.of(context)!.isFirst){
            Navigator.pop(context);
          }else{
            HomeCubit.get(context).changeBottomNavBarIndex(0, context);
            Navigator.pushNamedAndRemoveUntil(context, 'homeLayout', (route) => false);
          }

        }
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmNewPasswordController.clear();
        CacheHelper.removeData(key: AppConstant.changePassword);
        return true;
      },
      child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          if(state is FailedNoInternetConnectionState){
            snackBarMessage(
                context: context,
                message: locale.no_internet,
                snackbarState: SnackbarState.error,
                duration: const Duration(seconds: 2));
          }

          if (state is SuccessChangePasswordState) {
            if (token != null) {
              Navigator.pushReplacementNamed(context, 'homeLayout');
            } else {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            }
            CacheHelper.removeData(key: AppConstant.changePassword);
            currentPasswordController.clear();
            newPasswordController.clear();
            confirmNewPasswordController.clear();
          }
          if (state is FailedChangePasswordState) {
            snackBarMessage(
                displayBottom: false,
                context: context,
                message: state.error,
                snackbarState: SnackbarState.error,
                duration: const Duration(seconds: 1));
          }
        },
        builder: (context, state) {
          var cubit = context.read<AuthenticationCubit>();
          return Scaffold(
            appBar: AppBar(
              leading: BuildBackIcon(onTap: () {
                if (forgetPassword) {
                  showPopUp(
                    context: context,
                    textTitle: locale.areYouSure,
                    textOk: locale.ok,
                    textCenter: '',
                    onPress: () {
                      currentPasswordController.clear();
                      newPasswordController.clear();
                      confirmNewPasswordController.clear();
                      Navigator.pushReplacementNamed(context, 'homeLayout');
                    },
                  );
                }else{
                  if(!ModalRoute.of(context)!.isFirst){
                    Navigator.pop(context);
                  }else{
                    HomeCubit.get(context).changeBottomNavBarIndex(0, context);
                    Navigator.pushNamedAndRemoveUntil(context, 'homeLayout', (route) => false);
                  }
                }

              }),
              centerTitle: true,
              title: Text(
                locale.changePassword,
                style: font.titleMedium!.copyWith(fontSize: 18.sp),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding:
                  EdgeInsets.only(top: 50.h, left: w / 25, right: w / 25),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        if(token != null && !forgetPassword)
                          BuildDefaultTextField(
                              backGroundColor: Colors.white,
                              maxLenght: 128,
                              controller: currentPasswordController,
                              width: double.infinity,
                              height: h / 16.8,
                              withText: false,
                              cubit: cubit,
                              inputType: TextInputType.text,
                              withEyeVisible: false,
                              hintText: locale.currentPassword,
                              onValidate: (value) {
                                if (value!.isEmpty) {
                                  return locale.enterPassword;
                                } else if (value.length < 6) {
                                  return locale.enterValidPassword;
                                }
                                return null;
                              },
                              isObscured: true,
                              context: context),
                        if(token != null && !forgetPassword)
                          SizedBox(
                            height: 20.h,
                          ),
                        if(token != null && !forgetPassword)
                          GestureDetector(
                            onTap: () {
                              OtpCubit.get(context).sendCodeOtp(
                                  email: ProfileCubit
                                      .get(context)
                                      .userDataModel!
                                      .user!
                                      .email,
                                  phone: ProfileCubit
                                      .get(context)
                                      .userDataModel!
                                      .user!
                                      .phoneNumber
                              );
                              CacheHelper.saveData(key: AppConstant.otpScreen, value: true);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OtpScreen(
                                          forgetPass: true,
                                          emailOrPhone: ProfileCubit
                                              .get(context)
                                              .userDataModel!
                                              .user!
                                              .email ?? ProfileCubit
                                              .get(context)
                                              .userDataModel!
                                              .user!
                                              .phoneNumber!,
                                          haveToken: true,
                                        ),
                                  ));
                              CacheHelper.saveData(
                                  key: AppConstant.changePassword,
                                  value: true);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  locale.forgot_password,
                                  style: font.titleMedium!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                )
                              ],
                            ),
                          ),
                        SizedBox(
                          height: 20.h,
                        ),
                        BuildDefaultTextField(
                            backGroundColor: Colors.white,
                            maxLenght: 128,
                            controller: newPasswordController,
                            width: double.infinity,
                            height: h / 16.8,
                            withText: false,
                            cubit: cubit,
                            inputType: TextInputType.text,
                            withEyeVisible: false,
                            hintText: locale.newPassword,
                            onValidate: (value) {
                              if (value!.isEmpty) {
                                return locale.enterPassword;
                              } else if (value.length < 6) {
                                return locale.enterValidPassword;
                              }
                              return null;
                            },
                            isObscured: true,
                            context: context),
                        SizedBox(
                          height: 20.h,
                        ),
                        BuildDefaultTextField(
                            withEyeVisible: false,
                            cubit: cubit,
                            backGroundColor: Colors.white,
                            maxLenght: 128,
                            width: double.infinity,
                            height: h / 16.8,
                            withText: false,
                            onValidate: (value) {
                              if (value!.isEmpty) {
                                return locale.enterPassword;
                              } else if (value.length < 6) {
                                return locale.enterValidPassword;
                              } else if (newPasswordController.text !=
                                  confirmNewPasswordController.text) {
                                return locale.twoPasswordNotSimilar;
                              }
                              return null;
                            },
                            controller: confirmNewPasswordController,
                            inputType: TextInputType.text,
                            hintText: locale.retypeNewPassword,
                            isObscured: true,
                            context: context),
                        SizedBox(
                          height: 90.h,
                        ),
                        state is LoadingChangePasswordState
                            ? const Center(child: CircularProgressIndicator(
                          color: ColorConstant.primaryColor,))
                            : BuildDefaultButton(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                if (token != null && !forgetPassword) {
                                  cubit.changePassword(

                                      currentPassword:
                                      currentPasswordController.text,
                                      newPassword: newPasswordController.text);
                                } else {
                                  cubit.forgetPassword(

                                      email: isEmail(emailOrPhone!)
                                          ? emailOrPhone
                                          : null,
                                      phone: !isEmail(emailOrPhone!)
                                          ? emailOrPhone
                                          : null,
                                      newPassword: newPasswordController.text);
                                }
                              }
                            },
                            text: locale.save_changes,
                            color: ColorConstant.primaryColor,
                            elevation: 4,
                            context: context),
                        SizedBox(
                          height: 18.h,
                        ),
                        Text(
                          locale.keepYourPassword,
                          style: font.displayMedium!.copyWith(fontSize: 12.sp),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
