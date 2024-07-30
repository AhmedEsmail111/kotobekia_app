import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/authentication/authentication_cubit.dart';
import 'package:kotobekia/shared/component/default_button_in_app.dart';
import 'package:kotobekia/shared/component/default_text_form_in_app.dart';
import 'package:kotobekia/shared/component/back_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kotobekia/shared/component/snakbar_message.dart';
import 'package:kotobekia/shared/styles/colors.dart';

class EnterNewPasswordScreen extends StatelessWidget {
  const EnterNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme font = Theme.of(context).textTheme;

    final locale = AppLocalizations.of(context);
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    var formKey = GlobalKey<FormState>();
    var passwordController = TextEditingController();
    var confirmPasswordController = TextEditingController();
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if(state is FailedNoInternetConnectionState){
          snackBarMessage(
              context: context,
              message: locale!.no_internet,
              snackbarState: SnackbarState.error,
              duration: const Duration(seconds: 2));
        }

      },
      builder: (context, state) {
        var cubit = context.read<AuthenticationCubit>();
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding:
                EdgeInsets.only(top: 23.h, left: w / 25, right: w / 25),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'كلمة المرور الجديدة',
                            style: font.titleMedium!.copyWith(fontSize: 18.sp),
                          ),
                          SizedBox(
                            width: 63.w,
                          ),
                          BuildBackIcon(onTap: (){
                            Navigator.pop(context);
                          }),
                        ],
                      ),
                      SizedBox(
                        height: 60.h,
                      ),
                      Text(
                        'قم بإدخال رقم سري جديد',
                        style: font.titleMedium!.copyWith(fontSize: 18.sp),
                      ),
                      Text(
                        'تأكد من إدخال كلمة مرور قوية لا تقل عن 8 أحرف\n لا يستطيع احد الوصول اليها',
                        style: font.displayMedium!.copyWith(fontSize: 14.sp),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      BuildDefaultTextField(
                          withEyeVisible: true,numberOfFormPass: 1,

                          cubit: cubit,
                          backGroundColor: Colors.white,
                          maxLenght: 128,
                          controller: passwordController,
                          width: double.infinity,
                          height: h / 16.8,
                          withText: false,
                          onValidate: (value) {
                            if (value!.isEmpty) {
                              return "الرجاء إدخال كلمة المرور.";
                            } else if (value.length < 6) {
                              return "يجب أن تكون كلمة المرور على الأقل 6 أحرف.";
                            }
                            return null;
                          },
                          inputType: TextInputType.text,
                          hintText: ' كتابة كلمة السر الجديدة',
                          isObscured: true,
                          context: context),
                      SizedBox(
                        height: h / 52,
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
                              return "الرجاء إدخال تأكيد كلمة المرور.";
                            } else if (value.length < 6) {
                              return "يجب أن تكون كلمة المرور على الأقل 6 أحرف.";
                            } else if (passwordController.text !=
                                confirmPasswordController.text) {
                              return "كلمة المرور وتأكيد كلمة المرور غير متطابقين.";
                            }
                            return null;
                          },
                          controller: confirmPasswordController,
                          inputType: TextInputType.text,
                          hintText: 'أعد كتابة كلمة السر الجديدة',
                          isObscured: true,
                          context: context),
                      SizedBox(
                        height: 200 .h,
                      ),
                      BuildDefaultButton(
                          onTap: () {
                            if (formKey.currentState!.validate()) {}
                          },
                          text: 'إستمرار',
                          color: ColorConstant.primaryColor,
                          elevation: 4,
                          context: context),

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
