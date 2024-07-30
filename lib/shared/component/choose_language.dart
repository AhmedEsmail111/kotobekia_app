import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kotobekia/controller/language/language_cubit.dart';
import 'package:kotobekia/controller/language/language_states.dart';
import 'package:kotobekia/shared/component/language_column_in_boarding_screen.dart';

class BuildChooseLanguage extends StatelessWidget {
  const BuildChooseLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageStates>(
      builder: (context, state) {
        var cubit = LanguageCubit.get(context);
        double w = MediaQuery.sizeOf(context).width;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BuildLanguageColumn(
                onTap: () {
                  cubit.changeLanguage(false);
                },
                check: cubit.index == 0 ? true : false,
                containerText: 'Aa',
                languageText: 'English',
                context: context),
            SizedBox(
              width: w / 6.5,
            ),
            BuildLanguageColumn(
                onTap: () {
                  cubit.changeLanguage(true);
                },
                check: cubit.index == 1 ? true : false,
                containerText: 'ض',
                languageText: 'العربية',
                context: context)
          ],
        );
      },
    );
  }
}
