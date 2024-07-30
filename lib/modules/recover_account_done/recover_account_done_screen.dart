import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/authentication/authentication_cubit.dart';
import 'package:kotobekia/shared/component/default_button_in_app.dart';
import 'package:kotobekia/shared/component/authentication/row_text_and_link.dart';
import 'package:kotobekia/shared/component/back_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kotobekia/shared/constants/images/images_constant.dart';
import 'package:kotobekia/shared/styles/colors.dart';

class RecoverAccountDoneScreen extends StatelessWidget {
  const RecoverAccountDoneScreen({super.key});

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
    var passwordController = TextEditingController();
    var confirmPasswordController = TextEditingController();
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {},
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'تم الاسترداد بنجاح',
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
                        height: 160.h,
                      ),
                      Image.asset(ImageConstant.recoverDoneImage),
                      SizedBox(
                        height: 40.h,
                      ),
                      Text(
                        'أحتفظ بكلمة المرور  في مكان أمن حتي تستطيع الرجوع لحسابك دائما',
                        style: font.titleMedium!.copyWith(fontSize: 11.sp),),
                      SizedBox(
                        height: 40.h,
                      ),

                      BuildDefaultButton(
                        withBorder: false,
                          onTap: () {
                            if (formKey.currentState!.validate()) {}
                          },
                          text: 'إستمرار',
                          color: ColorConstant.primaryColor,
                          elevation: 4,
                          context: context),
                      SizedBox(
                        height: 40.h,
                      ),
                      BuildRowTextAndLink(
                          fontSize: w / 30,
                          onTap: () {

                          },
                          text: 'تحتاج لمساعدة؟',
                          textLink: 'تواصل معنا',
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
