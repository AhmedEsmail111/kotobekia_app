import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/home/home_cubit.dart';
import 'package:kotobekia/controller/home/home_state.dart';
import 'package:kotobekia/modules/create_account/create_account_screen.dart';
import 'package:kotobekia/modules/login/Login_screen.dart';
import 'package:kotobekia/shared/component/back_icon.dart';
import 'package:kotobekia/shared/component/navigation.dart';

import '../../shared/component/default_button_in_app.dart';
import '../../shared/constants/images/images_constant.dart';
import '../../shared/styles/colors.dart';

class GetStartScreen extends StatelessWidget {
  const GetStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;


    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        var cubit=context.read<HomeCubit>();
        Future<bool> onWillPop() async {
          Navigator.pushReplacementNamed(context, 'homeLayout');
          cubit.changeBottomNavBarIndex(0,context);
          return true;
        }
        return Scaffold(
            body: WillPopScope(
          onWillPop: onWillPop,
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    BuildBackIcon(
                      backX: true,
                      onTap: () {
                  cubit.changeBottomNavBarIndex(0,context);
                  Navigator.pushReplacementNamed(context, 'homeLayout');
                },)
                  ],
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: h / 8.5, left: w / 16, right: w / 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset(
                        ImageConstant.getStartImage,
                        width: w / 1.21,
                        height: h / 2.7,
                      ),
                      SizedBox(
                        height: h / 17.5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: w / 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  locale!.welcome,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontSize: w / 20.5),
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Text(
                                  locale.kotobekia,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontSize: w / 20.5,
                                          color: ColorConstant.startingColor),
                                ),
                              ],
                            ),
                            Text(
                              locale.slogan,
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: h / 17.5, left: w / 22.5, right: w / 22.5),
                  child: BuildDefaultButton(
                      withBorder: false,
                      onTap: () {
                        pushWithAnimationLeftAndBottom(context: context,
                            widget: const CreateAccountScreen());
                      },
                      text: locale.register,
                      color: ColorConstant.primaryColor,
                      elevation: 0,
                      context: context),
                ),
                SizedBox(
                  height: h / 38,
                ),
                InkWell(
                  onTap: () {
                    pushWithAnimationLeftAndBottom(context: context,
                        widget: const LoginScreen());
                  },
                  child: Text(
                    locale.login,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: w / 22.5, decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ),
        ));
      },
    );
  }
}
