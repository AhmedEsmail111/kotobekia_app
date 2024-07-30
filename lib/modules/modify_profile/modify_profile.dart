import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/profile/profile_cubit.dart';
import 'package:kotobekia/controller/profile/profile_states.dart';
import 'package:kotobekia/modules/create_account/create_account_screen.dart';
import 'package:kotobekia/shared/component/back_icon.dart';
import 'package:kotobekia/shared/component/default_button_in_app.dart';
import 'package:kotobekia/shared/component/default_text_form_in_app.dart';
import 'package:kotobekia/shared/component/authentication/gender_row_in_auth.dart';
import 'package:kotobekia/shared/component/dialogue_message.dart';
import 'package:kotobekia/shared/component/loading_indicator.dart';
import 'package:kotobekia/shared/component/snakbar_message.dart';
import 'package:kotobekia/shared/constants/images/images_constant.dart';
import 'package:kotobekia/shared/styles/colors.dart';


class ModifyProfileScreen extends StatelessWidget {
  const ModifyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    final locale = AppLocalizations.of(context);
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    final profileCubit = ProfileCubit.get(context);
    var nameController = TextEditingController();
    var emailOrPhoneController = TextEditingController();
    var dayController = TextEditingController();
    var monthController = TextEditingController();
    var yearController = TextEditingController();
    DateTime dateTime =
        DateTime.parse(profileCubit.userDataModel!.user!.birthDate!);
    nameController.text = profileCubit.userDataModel!.user!.fullName!;
    emailOrPhoneController.text = profileCubit.userDataModel!.user!.email ??
        profileCubit.userDataModel!.user!.phoneNumber!;
    dayController.text = dateTime.day.toString();
    monthController.text = dateTime.month.toString();
    yearController.text = dateTime.year.toString();
    String? _validateInput(String? value) {
      if (value == null || value.isEmpty) {
        return locale.enterEmailOrPhone;
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

    return BlocConsumer<ProfileCubit, ProfileStates>(
      listener: (context, state) {
        if (state is SuccessUpdateUserDataState) {
          snackBarMessage(
              context: context,
              message:state.message ,
              snackbarState: SnackbarState.success,
              duration: const Duration(seconds: 1));
        }
        if (state is FailureUpdateUserDataState) {
          snackBarMessage(
              context: context,
              message:state.error,
              snackbarState: SnackbarState.success,
              duration: const Duration(seconds: 1));
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          leading: BuildBackIcon(onTap: () {
            Navigator.pop(context);
          }),
          title: Text(
            locale.view_profile,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: profileCubit.userDataModel != null
            ? Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40.w,
                            backgroundImage:
                                profileCubit.userDataModel!.user!.gender ==
                                        'male'
                                    ? const AssetImage(
                                        ImageConstant.userMaleImage,
                                      )
                                    : const AssetImage(
                                        ImageConstant.userFemaleImage,
                                      ),
                          ),
                          SizedBox(
                            height: 24.h,
                          ),
                          Column(
                            children: [
                              BuildDefaultTextField(
                                  withEyeVisible: false,
                                  backGroundColor: Colors.white,
                                  maxLenght: 100,
                                  controller: nameController,
                                  width: double.infinity,
                                  height: h / 16.8,
                                  withText: false,
                                  onValidate: (value) {
                                    if (value!.isEmpty) {
                                      return locale.enterName;
                                    }
                                    return null;
                                  },
                                  isObscured: false,
                                  inputType: TextInputType.name,
                                  hintText: locale.full_name_hint,
                                  context: context),
                              SizedBox(
                                height: 16.h,
                              ),
                              BuildDefaultTextField(
                                  withEyeVisible: false,
                                  backGroundColor: Colors.white,
                                  maxLenght: 320,
                                  controller: emailOrPhoneController,
                                  width: double.infinity,
                                  height: h / 16.8,
                                  withText: false,
                                  isObscured: false,
                                  onValidate: _validateInput,
                                  inputType: TextInputType.emailAddress,
                                  hintText: locale.hintEmailOrPhone,
                                  context: context),
                              SizedBox(
                                height: 16.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                          return locale.empty;
                                        }
                                        return null;
                                      },
                                      hintText: locale.one_day,
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
                                          return locale.empty;
                                        }
                                        return null;
                                      },
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
                                          return locale.empty;
                                        }
                                        return null;
                                      },
                                      context: context,
                                      width: w / 2.6,
                                      height: h / 17.5,
                                      isObscured: false),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16.w,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              BuildGenderRow(
                                  genderValue: profileCubit.genderValue,
                                  onChange: (gender) {
                                    profileCubit.changeGender(0);
                                  },
                                  context: context,
                                  text: locale.male,
                                  character: gender.Male),
                              SizedBox(
                                width: 8.w,
                              ),
                              BuildGenderRow(
                                  genderValue: profileCubit.genderValue,
                                  onChange: (gender) {
                                    profileCubit.changeGender(1);
                                  },
                                  context: context,
                                  text: locale.female,
                                  character: gender.Female)
                            ],
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                          BuildDefaultButton(
                            withBorder: true,
                            onTap: () {
                              Navigator.pushNamed(context, 'changePassword');
                            },
                            text: locale.modify_password,
                            color: Theme.of(context).cardColor,
                            elevation: 0,
                            context: context,
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          state is LoadingUpdateUserDataState
                              ? const CircularProgressIndicator(
                                  color: ColorConstant.primaryColor,
                                )
                              : BuildDefaultButton(
                                  withBorder: false,
                                  onTap: () {
                                    if ((int.parse(dayController.text) < 1 ||
                                            int.parse(dayController.text) >
                                                31) &&
                                        formKey.currentState!.validate()) {
                                      buildDialogue(
                                          context: context,
                                          message: locale.invalidDay);
                                    } else if ((int.parse(
                                                    monthController.text) <
                                                1 ||
                                            int.parse(monthController.text) >
                                                12) &&
                                        formKey.currentState!.validate()) {
                                      buildDialogue(
                                          context: context,
                                          message: locale.invalidMonth);
                                    } else if ((int.parse(yearController.text) <
                                                1900 ||
                                            int.parse(yearController.text) >
                                                DateTime.now().year) &&
                                        formKey.currentState!.validate()) {
                                      buildDialogue(
                                          context: context,
                                          message: locale.invalidYear);
                                    } else if (formKey.currentState!
                                        .validate()) {
                                      String birthDate =
                                          '${monthController.text}/${dayController.text}/${yearController.text}';
                                      profileCubit.updateProfile(
                                          birthDate: birthDate,
                                          email: isEmail(
                                                  emailOrPhoneController.text)
                                              ? emailOrPhoneController.text
                                              : null,
                                          phone: !isEmail(
                                                  emailOrPhoneController.text)
                                              ? emailOrPhoneController.text
                                              : null,
                                          sex: profileCubit.genderValue ==
                                                  gender.Male
                                              ? 'male'
                                              : 'female',
                                          name: nameController.text,
                                          id: profileCubit
                                              .userDataModel!.user!.sId!);
                                    }
                                  },
                                  text: locale.save_changes,
                                  color: ColorConstant.primaryColor,
                                  elevation: 3,
                                  context: context,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : const BuildLoadingIndicator(),
      ),
    );
  }
}
