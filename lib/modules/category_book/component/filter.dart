import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/category/category_cubit.dart';
import 'package:kotobekia/controller/category/category_states.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kotobekia/modules/category_book/component/checkBox.dart';
import 'package:kotobekia/shared/component/default_button_in_app.dart';
import 'package:kotobekia/shared/styles/colors.dart';

class BuildBoxFilter extends StatelessWidget {
  const BuildBoxFilter({super.key, required this.categoryIndex});

  final int categoryIndex;

  @override
  Widget build(BuildContext context) {

    final locale = AppLocalizations.of(context);

    var font = Theme.of(context).textTheme;
    return BlocBuilder<CategoryCubit, CategoryStates>(
      builder: (context, state) {
        var categoryCubit = context.read<CategoryCubit>();
        return Container(
          padding: EdgeInsets.all(16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      borderRadius: BorderRadius.circular(8.r),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text('cancel',)),
                  const Spacer(),
                  Text(
                    locale!.postFilter,
                    style: font.displayLarge!.copyWith(fontSize: 21.sp),
                  ),
                  const Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(8.r),
                    onTap: () {
                      categoryCubit.resetBoxFilter();
                    },
                    child: Text('Reset',style: font.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp),),
                  ),
                ],
              ),
              SizedBox(
                height: 25.h,
              ),

              SizedBox(
                height: 10.h,
              ),
              Text(locale.price,
                  style: font.bodyMedium!
                      .copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 5.h,
              ),
              Wrap(
                direction: Axis.horizontal,
                children: [
                  Row(
                    children: [
                      BuildCheckBox(
                        text: locale.free,
                        value: categoryCubit.free,
                        onChanged: (value) {
                          categoryCubit.changeBoxFilter(Filter.free, value!);
                        },
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      BuildCheckBox(
                        text: locale.paid,
                        value: categoryCubit.paid,
                        onChanged: (value) {
                          categoryCubit.changeBoxFilter(Filter.paid, value!);
                        },
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(locale.grade,
                  style: font.bodyMedium!
                      .copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 5.h,
              ),
              Wrap(
                direction: Axis.horizontal,
                children: [
                  Row(
                    children: [
                      BuildCheckBox(
                        text: locale.grade_one,
                        value: categoryCubit.gradeOne,
                        onChanged: (value) {
                          categoryCubit.changeBoxFilter(
                              Filter.gradeOne, value!);
                        },
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      BuildCheckBox(
                        text: locale.grade_two,
                        value: categoryCubit.gradeTwo,
                        onChanged: (value) {
                          categoryCubit.changeBoxFilter(
                              Filter.gradeTwo, value!);
                        },
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      BuildCheckBox(
                        text: locale.grade_three,
                        value: categoryCubit.gradeThree,
                        onChanged: (value) {
                          categoryCubit.changeBoxFilter(
                              Filter.gradeThree, value!);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              Wrap(
                direction: Axis.horizontal,
                children: [
                  BuildCheckBox(
                    text: locale.grade_four,
                    value: categoryCubit.gradeFour,
                    onChanged: (value) {
                      categoryCubit.changeBoxFilter(Filter.gradeFour, value!);
                    },
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  BuildCheckBox(
                    text: locale.grade_five,
                    value: categoryCubit.gradeFive,
                    onChanged: (value) {
                      categoryCubit.changeBoxFilter(Filter.gradeFive, value!);
                    },
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  BuildCheckBox(
                    text: locale.grade_six,
                    value: categoryCubit.gradeSix,
                    onChanged: (value) {
                      categoryCubit.changeBoxFilter(Filter.gradeSix, value!);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(locale.education_type,
                  style: font.bodyMedium!
                      .copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 5.h,
              ),
              Wrap(
                direction: Axis.horizontal,
                children: [
                  Row(
                    children: [
                      BuildCheckBox(
                        text: locale.general,
                        value: categoryCubit.general,
                        onChanged: (value) {
                          categoryCubit.changeBoxFilter(Filter.general, value!);
                        },
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      BuildCheckBox(
                        text: locale.azhar,
                        value: categoryCubit.azhar,
                        onChanged: (value) {
                          categoryCubit.changeBoxFilter(Filter.azhar, value!);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              SizedBox(
                height: 42.h,
                child: BuildDefaultButton(
                    onTap: () {
                      categoryCubit.getSpecificLevelEducation(categoryIndex);
                    Navigator.pop(context);
                      },
                    text: locale.save_changes,
                    color: ColorConstant.primaryColor,
                    elevation: 2,
                    context: context),
              ),
              //Text(locale.free),
            ],
          ),
        );
      },
    );
  }
}
