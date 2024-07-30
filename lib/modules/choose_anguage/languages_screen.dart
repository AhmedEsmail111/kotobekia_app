import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kotobekia/controller/language/language_cubit.dart';
import 'package:kotobekia/controller/language/language_states.dart';
import 'package:kotobekia/shared/component/choose_language.dart';
import 'package:kotobekia/shared/constants/images/images_constant.dart';

import '../../shared/component/default_button_in_app.dart';
import '../../shared/component/language_column_in_boarding_screen.dart';
import '../../shared/styles/colors.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    TextTheme font = Theme.of(context).textTheme;
    return BlocConsumer<LanguageCubit, LanguageStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = LanguageCubit.get(context);
        return Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding:
                  EdgeInsets.only(top: h / 7.2, left: w / 25, right: w / 25),
              child: Column(
                children: [
                  Image.asset(ImageConstant.logoImage),
                  SizedBox(
                    height: w / 7,
                  ),
                  Text(
                    'إختر لغتك المفضلة',
                    style: font.bodyLarge,
                  ),
                  SizedBox(
                    height: h / 31,
                  ),
                  const BuildChooseLanguage(),
                  SizedBox(
                    height: h / 9.2,
                  ),
                  BuildDefaultButton(
                    onTap: cubit.index != null
                        ? () {
                      cubit.setDefaultLanguage();
                      Navigator.pushReplacementNamed(
                          context, 'homeLayout');
                          }
                        : null,
                    text: 'متابعة',
                    color: ColorConstant.primaryColor,
                    elevation: 4,
                    context: context,
                    withBorder: false,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
