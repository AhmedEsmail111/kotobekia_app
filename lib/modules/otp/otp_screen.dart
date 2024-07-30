import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/authentication/authentication_cubit.dart';
import 'package:kotobekia/controller/home/home_cubit.dart';
import 'package:kotobekia/controller/otp/otp_cubit.dart';
import 'package:kotobekia/controller/profile/profile_cubit.dart';
import 'package:kotobekia/modules/change_passwrod/chnage_password_screen.dart';
import 'package:kotobekia/modules/create_account/create_account_screen.dart';
import 'package:kotobekia/shared/component/back_icon.dart';
import 'package:kotobekia/shared/component/default_button_in_app.dart';
import 'package:kotobekia/shared/component/authentication/row_text_and_link.dart';
import 'package:kotobekia/shared/component/general_pop_up.dart';
import 'package:kotobekia/shared/component/navigation.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/constants/images/images_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import '../../shared/component/snakbar_message.dart';
import '../../shared/styles/colors.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen(
      {super.key,
      this.haveToken = false,
      this.emailOrPhone,
      this.forgetPass = false});

  final bool haveToken;
  final String? emailOrPhone;
  final bool forgetPass;

  @override
  Widget build(BuildContext context) {
    if (emailOrPhone != null) {
      CacheHelper.saveData(value: emailOrPhone, key: AppConstant.emailOrPhone);
    }

    final locale = AppLocalizations.of(context);
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    TextTheme font = Theme.of(context).textTheme;

    var cubit = context.read<OtpCubit>();
    String? token = CacheHelper.getData(key: AppConstant.token);
    return BlocConsumer<OtpCubit, OtpState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            showPopUp(
              context: context,
              textTitle: locale.areYouSure,
              textOk: locale.ok,
              textCenter: locale.goBackInOtp,
              onPress: () {
                if (!haveToken) {
                  CacheHelper.removeData(key: AppConstant.token);
                  ProfileCubit.get(context).hasAccount = false;
                }
                AuthenticationCubit.get(context).identityUserModel = null;
                CacheHelper.removeData(key: AppConstant.otpScreen);
                if(!ModalRoute.of(context)!.isFirst){
                  Navigator.pop(context);
                  Navigator.pop(context);
                }else{
                  HomeCubit.get(context).changeBottomNavBarIndex(0, context);
                  Navigator.pushNamedAndRemoveUntil(context, 'homeLayout', (route) => false);
                }

                cubit.firstNumberController.clear();
                cubit.secondNumberController.clear();
                cubit.thirdNumberController.clear();
                cubit.fourNumberController.clear();
              },
            );
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              leading: BuildBackIcon(
                onTap: () {
                  showPopUp(
                    context: context,
                    textTitle: locale.areYouSure,
                    textOk: locale.ok,
                    textCenter: locale.goBackInOtp,
                    onPress: () {
                      if (!haveToken) {
                        CacheHelper.removeData(key: AppConstant.token);
                        ProfileCubit.get(context).hasAccount = false;
                      }
                      AuthenticationCubit.get(context).identityUserModel = null;
                      CacheHelper.removeData(key: AppConstant.otpScreen);
                      if(!ModalRoute.of(context)!.isFirst){
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }else{
                        HomeCubit.get(context).changeBottomNavBarIndex(0, context);
                        Navigator.pushNamedAndRemoveUntil(context, 'homeLayout', (route) => false);
                      }
                      cubit.firstNumberController.clear();
                      cubit.secondNumberController.clear();
                      cubit.thirdNumberController.clear();
                      cubit.fourNumberController.clear();
                    },
                  );
                },
              ),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding:
                    EdgeInsets.only(top: h /90, left: w / 25, right: w / 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: h / 18),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            locale.verify_info,
                            style: font.bodyLarge,
                          ),
                          SizedBox(
                            height: h / 26,
                          ),
                          Image.asset(
                            ImageConstant.messageImage,
                            width: w / 3,
                            height: h / 9.6,
                          ),
                          SizedBox(
                            height: h / 26,
                          ),
                          Text(
                            locale.enter_otp,
                            style: font.titleMedium,
                          ),
                          SizedBox(
                            height: h / 26,
                          ),
                          Row(
                            children: [
                              Text(
                                isEmail(CacheHelper.getData(
                                        key: AppConstant.emailOrPhone)!)
                                    ? locale.otp_message_email
                                    : locale.otp_message_whatsapp,
                                style: font.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: w / 29),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                locale.enter_code,
                                style: font.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: w / 28),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: h / 55.5,
                          ),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: OtpTextField(
                              borderRadius: BorderRadius.circular(15.r),
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              fieldWidth: 60.w,
                              numberOfFields: 4,
                              borderColor: const Color(0xFF512DA8),
                              showFieldAsBox: true,
                              onCodeChanged: (String code) {
                                cubit.otpResultCollect();
                              },
                              onSubmit: (value) {
                                cubit.otpResult = value;
                              },
                            ),
                          ),
                          SizedBox(
                            height: h / 15,
                          ),
                          state is! LoadingVerifyOtpState &&
                                  state is! LoadingVerifyForgetOtpState
                              ? BuildDefaultButton(
                                  onTap: cubit.otpResult.length == 4
                                      ? () {
                                          if (token != null && !forgetPass) {
                                            cubit.verifyOtp(
                                                email: isEmail(
                                                        CacheHelper.getData(
                                                            key: AppConstant
                                                                .emailOrPhone)!)
                                                    ? CacheHelper.getData(
                                                        key: AppConstant
                                                            .emailOrPhone)!
                                                    : null,
                                                phone: !isEmail(
                                                        CacheHelper.getData(
                                                            key: AppConstant
                                                                .emailOrPhone)!)
                                                    ? CacheHelper.getData(
                                                        key: AppConstant
                                                            .emailOrPhone)!
                                                    : null,
                                                otp: cubit.otpResult);
                                          } else {
                                            cubit.verifyForgetCode(
                                                email: isEmail(
                                                        CacheHelper.getData(
                                                            key: AppConstant
                                                                .emailOrPhone)!)
                                                    ? CacheHelper.getData(
                                                        key: AppConstant
                                                            .emailOrPhone)!
                                                    : null,
                                                phone: !isEmail(
                                                        CacheHelper.getData(
                                                            key: AppConstant
                                                                .emailOrPhone)!)
                                                    ? CacheHelper.getData(
                                                        key: AppConstant
                                                            .emailOrPhone)!
                                                    : null,
                                                forgetCode: cubit.otpResult);
                                          }
                                        }
                                      : null,
                                  text: locale.confirm,
                                  color: ColorConstant.primaryColor,
                                  elevation: 4,
                                  context: context,
                                  withBorder: false,
                                )
                              : const Center(
                                  child: CircularProgressIndicator(
                                    color: ColorConstant.primaryColor,
                                  ),
                                ),
                          SizedBox(
                            height: h / 26,
                          ),
                          BuildRowTextAndLink(
                              cubit: cubit,
                              fontSize: w / 25.5,
                              text: locale.have_no_otp,
                              textLink: locale.resend_otp,
                              context: context,
                              onTap: () {
                                cubit.resendOtp(
                                    email: CacheHelper.getData(
                                            key: AppConstant.emailOrPhone)
                                        .toString());
                                cubit.resendOtpTimer();
                              }),
                          SizedBox(
                            height: h / 6,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is FailedNoInternetConnectionOtpState) {
          snackBarMessage(
              context: context,
              message: locale.no_internet,
              snackbarState: SnackbarState.error,
              duration: const Duration(seconds: 2));
        }
        if (state is SuccessVerifyForgetOtpState) {
          pushWithAnimationLeftAndBottom(
              context: context,
              widget: ChangePasswordScreen(
                  forgetPassword: forgetPass,
                  emailOrPhone:
                      CacheHelper.getData(key: AppConstant.emailOrPhone)));
          CacheHelper.removeData(key: AppConstant.otpScreen);
          cubit.otpResult = '';
          cubit.firstNumberController.clear();
          cubit.secondNumberController.clear();
          cubit.thirdNumberController.clear();
          cubit.fourNumberController.clear();
        } else if (state is FailedVerifyForgetOtpState) {
          snackBarMessage(
              snackbarState: SnackbarState.error,
              context: context,
              message: state.error,
              duration: const Duration(seconds: 2));
        }

        if (state is SuccessVerifyOtpState) {
          AuthenticationCubit.get(context).sendFcmToken();
          Navigator.pushNamedAndRemoveUntil(
              context, 'verifiedEmail', (route) => false);
          CacheHelper.removeData(key: AppConstant.otpScreen);
          cubit.otpResult = '';
          cubit.firstNumberController.clear();
          cubit.secondNumberController.clear();
          cubit.thirdNumberController.clear();
          cubit.fourNumberController.clear();
        } else if (state is FailedVerifyOtpState) {
          snackBarMessage(
              snackbarState: SnackbarState.error,
              context: context,
              message: state.error,
              duration: const Duration(seconds: 2));
        }
      },
    );
  }
}
