import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kotobekia/controller/favorites/favorites_cubit.dart';
import 'package:kotobekia/controller/home/home_cubit.dart';
import 'package:kotobekia/modules/otp/otp_screen.dart';
import 'package:kotobekia/shared/component/dialogue_message.dart';
import 'package:kotobekia/shared/component/general_pop_up.dart';
import 'package:kotobekia/shared/component/snakbar_message.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/constants/icons/icons_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';

import '../../controller/authentication/authentication_cubit.dart';
import '../../shared/component/authentication/button_authentication_services.dart';
import '../../shared/component/default_button_in_app.dart';
import '../../shared/component/default_text_form_in_app.dart';
import '../../shared/component/authentication/gender_row_in_auth.dart';
import '../../shared/component/authentication/row_text_and_link.dart';
import '../../shared/component/authentication/tow_line_and_text_in_auth.dart';
import '../../shared/styles/colors.dart';

bool isEmail(String input) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(input);
}

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key,
    this.comefromHome=false});
final bool comefromHome;
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    var nameController = TextEditingController();
    var emailOrPhoneController = TextEditingController();
    var passwordController = TextEditingController();
    var confirmPasswordController = TextEditingController();
    var dayController = TextEditingController();
    var monthController = TextEditingController();
    var yearController = TextEditingController();
    TextTheme font = Theme.of(context).textTheme;
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    var formKey = GlobalKey<FormState>();
    String? _validateInput(String? value) {
      if (value == null || value.isEmpty) {
        return locale!.enterEmailOrPhone;
      }

      // Check if the input is a valid email
      if (RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
        return null;
      }

      // Check if the input is a valid Egyptian phone number
      if (RegExp(r'^01[0-2]{1}[0-9]{8}$').hasMatch(value.trim())) {
        return null;
      }

      return locale.enterValidEmailOrPhone;
    }


    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if(state is FailedNoInternetConnectionState){
          snackBarMessage(
              context: context,
              message: locale.no_internet,
              snackbarState: SnackbarState.error,
              duration: const Duration(seconds: 2));
        }

        if(state is SuccessUserAuthWithGoogleState){
          if (state.userModel.token == null) {
            snackBarMessage(
                snackbarState: SnackbarState.error,
                context: context,
                message: state.userModel.message.toString(),
                duration: const Duration(seconds: 2));
          } else {
            HomeCubit.get(context).changeBottomNavBarIndex(0, context);
            Navigator.pushNamedAndRemoveUntil(context, 'homeLayout', (route) => false);
            FavoritesCubit.get(context).getFavPosts();
            CacheHelper.saveData(
                key: AppConstant.token, value: state.userModel.token);
            CacheHelper.saveData(key: AppConstant.otpScreen, value: 1);
          }
        } else if (state is FailedUserAuthWithGoogleState) {
          snackBarMessage(
              snackbarState: SnackbarState.error,
              context: context,
              message: state.error,
              duration: const Duration(seconds: 2));
        }
        if (state is SuccessUserCreateAccountState) {
          if (state.userModel.token == null) {
            snackBarMessage(
                snackbarState: SnackbarState.error,
                context: context,
                message: state.userModel.message.toString(),
                duration: const Duration(seconds: 2));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      OtpScreen(emailOrPhone: emailOrPhoneController.text),
                ));
            CacheHelper.saveData(
                key: AppConstant.token, value: state.userModel.token);
            CacheHelper.saveData(key: AppConstant.otpScreen, value: true);
          }
        } else if (state is FailedUserCreateAccountState) {
          snackBarMessage(
              snackbarState: SnackbarState.error,
              context: context,
              message: state.error,
              duration: const Duration(seconds: 2));
        }
      },
      builder: (context, state) {
        var cubit = context.read<AuthenticationCubit>();
        return WillPopScope(
          onWillPop: () async{
            cubit.genderValue=gender.Other;
            return true;
          },
          child: Scaffold(
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: Padding(
                  padding:
                      EdgeInsets.only(top: h / 7.8, left: w / 25, right: w / 25),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Text(
                          locale.create_acount,
                          style: font.bodyLarge,
                        ),
                        SizedBox(
                          height: h / 55,
                        ),
                        Text(
                          locale.create_acount_slogan,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: h / 30,
                        ),
                        state is LoadingUserAuthWithGoogleState ||
                            state is LoadingSignInWithGoogleState?
                        const Center(child:  CircularProgressIndicator(color: ColorConstant.primaryColor,)):
                        BuildButtonAuthServices(
                            onTap: () {
                              cubit.signInWithGoogle(context: context);
                            },
                            text: locale.create_with_google,
                            buttonColor: ColorConstant.midGrayColor,
                            iconImage: IconConstant.googleIcon,
                            elevation: 0,
                            context: context),
                        SizedBox(
                          height: h / 35,
                        ),
                        BuildTowLineRowInAuth(context: context),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BuildDefaultTextField(
                                withEyeVisible: false,
                                backGroundColor: Colors.white,
                                maxLenght: 100,
                                controller: nameController,
                                width: double.infinity,
                                height: h / 16.8,
                                withText: true,
                                onValidate: (value) {
                                  if (value!.isEmpty) {
                                    return locale.enterName;
                                  }
                                  return null;
                                },
                                isObscured: false,
                                inputType: TextInputType.name,
                                hintText: locale.full_name_hint,
                                aboveFieldText: locale.full_name,
                                context: context),
                            SizedBox(
                              height: h / 52,
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
                            SizedBox(
                              height: h / 52,
                            ),
                            BuildDefaultTextField(
                                withEyeVisible: true,
                                cubit: cubit,
                                backGroundColor: Colors.white,
                                maxLenght: 128,
                                controller: passwordController,
                                width: double.infinity,
                                height: h / 16.8,
                                withText: true,
                                onValidate: (value) {
                                  if (value!.isEmpty) {
                                    return locale.enterPassword;
                                  } else if (value.length < 6) {
                                    return locale.enterValidPassword;
                                  }
                                  return null;
                                },
                                inputType: TextInputType.text,
                                hintText: '*****************',
                                numberOfFormPass: 1,
                                isObscured: true,
                                aboveFieldText: locale.password,
                                context: context),
                            SizedBox(
                              height: h / 52,
                            ),
                            BuildDefaultTextField(
                                withEyeVisible: true,
                                cubit: cubit,
                                backGroundColor: Colors.white,
                                maxLenght: 128,
                                width: double.infinity,
                                height: h / 16.8,
                                withText: true,
                                numberOfFormPass: 2,
                                onValidate: (value) {
                                  if (value!.isEmpty) {
                                    return locale.enterPassword;
                                  } else if (value.length < 6) {
                                    return locale.enterValidPassword;
                                  } else if (passwordController.text.trim() !=
                                      confirmPasswordController.text.trim()) {
                                    return locale.twoPasswordNotSimilar;
                                  }
                                  return null;
                                },
                                controller: confirmPasswordController,
                                inputType: TextInputType.text,
                                hintText: '*****************',
                                isObscured: true,
                                aboveFieldText: locale.rewrite_password,
                                context: context),
                            SizedBox(
                              height: h / 52,
                            ),
                            Text(
                              locale.gender,
                              style: font.titleMedium!.copyWith(
                                fontSize:
                                    MediaQuery.of(context).size.width / 25.5,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                BuildGenderRow(
                                    genderValue: cubit.genderValue,
                                    onChange: (gender) {
                                      cubit.changeGender(0);
                                    },
                                    context: context,
                                    text: locale.male,
                                    character: gender.Male),
                                SizedBox(
                                  width: w / 20,
                                ),
                                BuildGenderRow(
                                    genderValue: cubit.genderValue,
                                    onChange: (gender) {
                                      cubit.changeGender(1);
                                    },
                                    context: context,
                                    text: locale.female,
                                    character: gender.Female)
                              ],
                            ),
                            SizedBox(
                              height: h / 52,
                            ),
                            Text(
                              locale.birth_day,
                              style: font.titleMedium!.copyWith(
                                fontSize:
                                    MediaQuery.of(context).size.width / 25.5,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BuildDefaultTextField(
                                    withEyeVisible: false,
                                    backGroundColor: Colors.white,
                                    maxLenght: 2,
                                    inputType: TextInputType.number,
                                    withText: false,
                                    controller: dayController,
                                    onValidate: (value) {
                                      if (value!.isEmpty) {
                                        return 'فارغ';
                                      }
                                      return null;
                                    },
                                    hintText: locale.one_day,
                                    aboveFieldText: '',
                                    context: context,
                                    width: w / 5.5,
                                    height: h / 17.5,
                                    isObscured: false),
                                BuildDefaultTextField(
                                    withEyeVisible: false,
                                    backGroundColor: Colors.white,
                                    maxLenght: 2,
                                    inputType: TextInputType.number,
                                    withText: false,
                                    hintText: locale.one_month,
                                    controller: monthController,
                                    onValidate: (value) {
                                      if (value!.isEmpty) {
                                        return 'فارغ';
                                      }
                                      return null;
                                    },
                                    aboveFieldText: '',
                                    context: context,
                                    width: w / 5,
                                    height: h / 17.5,
                                    isObscured: false),
                                BuildDefaultTextField(
                                    withEyeVisible: false,
                                    backGroundColor: Colors.white,
                                    inputType: TextInputType.number,
                                    withText: false,
                                    maxLenght: 4,
                                    hintText: locale.one_year,
                                    controller: yearController,
                                    onValidate: (value) {
                                      if (value!.isEmpty) {
                                        return 'فارغ';
                                      }
                                      return null;
                                    },
                                    aboveFieldText: '',
                                    context: context,
                                    width: w / 2.6,
                                    height: h / 17.5,
                                    isObscured: false),
                              ],
                            ),
                            SizedBox(
                              height: h / 28,
                            ),
                            state is! LoadingUserCreateAccountState
                                ? BuildDefaultButton(
                                    onTap: () {
                                      if (cubit.genderValue == gender.Other &&
                                          formKey.currentState!.validate()) {
                                        buildDialogue(
                                            context: context,
                                            message: locale.selectYourGender);
                                      }
                                      else if ((int.parse(dayController.text) < 1 ||
                                              int.parse(dayController.text) >
                                                  31) &&
                                          formKey.currentState!.validate()) {
                                        buildDialogue(
                                            context: context,
                                            message: locale.invalidDay);
                                      } else if ((int.parse(monthController.text) < 1 ||
                                          int.parse(monthController.text) >
                                              12) &&
                                          formKey.currentState!.validate()) {
                                        buildDialogue(
                                            context: context,
                                            message: locale.invalidMonth);
                                      }else if ((int.parse(yearController.text) < 1900 ||
                                          int.parse(yearController.text) >
                                              DateTime.now().year) &&
                                          formKey.currentState!.validate()) {
                                        buildDialogue(
                                            context: context,
                                            message: locale.invalidYear);
                                      }else if (formKey.currentState!.validate()) {
                                        String birthDate =
                                            '${yearController.text.trim()}-${monthController.text.trim()}-${dayController.text.trim()}';

                                        cubit.userCreateAccount(
                                            email: isEmail(emailOrPhoneController
                                                    .text
                                                    .trim())
                                                ? emailOrPhoneController.text
                                                    .trim()
                                                : null,
                                            phone: !isEmail(emailOrPhoneController
                                                    .text
                                                    .trim())
                                                ? emailOrPhoneController.text
                                                    .trim()
                                                : null,
                                            password:
                                                passwordController.text.trim(),
                                            name: nameController.text.trim(),
                                            birthDate: birthDate.trim(),
                                            gender:
                                                cubit.genderValue == gender.Male
                                                    ? 'male'
                                                    : 'female');
                                      }
                                    },
                                    text: locale.create_acount,
                                    color: ColorConstant.primaryColor,
                                    elevation: 4,
                                    context: context,
                                    withBorder: false,
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(
                                        color: ColorConstant.primaryColor),
                                  ),
                            SizedBox(
                              height: h / 30,
                            ),
                            BuildRowTextAndLink(
                                fontSize: w / 30,
                                onTap: () {
                                  Navigator.pushNamed(context, 'login');
                                  if(!cubit.isObscureOne) {
                                    cubit.changeVisiabilityPassword(1);
                                  }
                                  if(!cubit.isObscureTwo) {
                                    cubit.changeVisiabilityPassword(2);
                                  }
                                },
                                text: locale.have_account,
                                textLink: locale.login,
                                context: context),
                            SizedBox(
                              height: h / 15,
                            ),
                          ],
                        )
                      ],
                    ),
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
