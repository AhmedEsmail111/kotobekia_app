import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/add_post/add_post_cubit.dart';
import 'package:kotobekia/controller/add_post/add_post_states.dart';
import 'package:kotobekia/controller/home/home_cubit.dart';
import 'package:kotobekia/controller/user_ads/user_ads_cubit.dart';
import 'package:kotobekia/models/post_model/post_model.dart';
import 'package:kotobekia/modules/add_post/component/button.dart';
import 'package:kotobekia/modules/add_post/component/drop_down_button.dart';
import 'package:kotobekia/modules/add_post/component/row_above_options.dart';
import 'package:kotobekia/shared/component/back_icon.dart';
import 'package:kotobekia/shared/component/default_button_in_app.dart';
import 'package:kotobekia/shared/component/default_text_form_in_app.dart';
import 'package:kotobekia/shared/component/dialogue_message.dart';
import 'package:kotobekia/shared/component/general_pop_up.dart';
import 'package:kotobekia/shared/component/snakbar_message.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/helper/functions.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:kotobekia/shared/styles/colors.dart';
import 'package:solar_icons/solar_icons.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final priceTextEditingController = TextEditingController();
    final locale = AppLocalizations.of(context)!;

    // to be able to match the backend requirements
    final grades = {
      locale.grade_one: 'grade_one',
      locale.grade_two: 'grade_two',
      locale.grade_three: 'grade_three',
      locale.grade_four: 'grade_four',
      locale.grade_five: 'grade_five',
      locale.grade_six: 'grade_six',
    };

    final semesters = {
      locale.first: 'first',
      locale.second: 'second',
      locale.both: 'both'
    };

    final educationTypes = {
      locale.general_type: 'general',
      locale.azhar: 'azhar',
      locale.any_type: 'other',
    };

    final educationLevels = {
      locale.kindergarten: '655b4ec133dd362ae53081f7',
      locale.primary: '655b4ecd33dd362ae53081f9',
      locale.preparatory: '655b4ee433dd362ae53081fb',
      locale.secondary: '655b4efb33dd362ae53081fd',
      locale.general: '655b4f0a33dd362ae53081ff'
    };

    final regionsDropDownItems = {
      locale.cairo: 'cairo',
      locale.giza: 'giza',
      locale.alexandria: 'alexandria',
      locale.dakahlia: 'dakahlia',
      locale.sharqia: 'sharqia',
      locale.monufia: 'monufia',
      locale.qalyubia: 'qalyubia',
      locale.beheira: 'beheira',
      locale.port_said: 'port_said',
      locale.damietta: 'damietta',
      locale.ismailia: 'ismailia',
      locale.suez: 'suez',
      locale.kafr_el_sheikh: 'kafr_el_sheikh',
      locale.fayoum: 'fayoum',
      locale.beni_suef: 'beni_suef',
      locale.matruh: 'matruh',
      locale.north_sinai: 'north_sinai',
      locale.south_sinai: 'south_sinai',
      locale.minya: 'minya',
      locale.asyut: 'asyut',
      locale.sohag: 'sohag',
      locale.qena: 'qena',
      locale.red_sea: 'red_sea',
      locale.luxor: 'luxor',
      locale.aswan: 'aswan',
    };
    final addPostCubit = AddPostCubit.get(context);

    return BlocConsumer<AddPostCubit, AddPostStates>(
      listener: (context, state) {
        if (state is SendNewPostSuccess) {
          addPostCubit.resetData();
          addPostCubit.selectedImages=[];
          HomeCubit.get(context).changeBottomNavBarIndex(0, context);
          Navigator.pop(context);
          UserAddsCubit.get(context).getUserPost();
        }
        if(state is SendNewPostFailure){
          snackBarMessage(
              inHome: true,
              displayBottom: false,
              context: context,
              message: state.message,
              snackbarState: SnackbarState.error,
              duration: const Duration(seconds: 3));
        }
        if (state is SendNewPostInternetFailure) {
          buildDialogue(context: context, message: state.message);
        }
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            showPopUp(
              context: context,
              textTitle: locale.cancel,
              textOk: locale.ok,
              textCenter: locale.cancelAddPost,
              onPress: () {
                Navigator.pop(context);
                Navigator.pop(context);
                addPostCubit.selectedImages=[];
                addPostCubit.resetData();
              },
            );
            return true;
          },
          child: Scaffold(
            bottomSheet: addPostCubit.isAddingPost
                ? const Center(child:  CircularProgressIndicator(color: ColorConstant.primaryColor))
                : Card(
                    elevation: 1,
                    child: SizedBox(
                      height: 65.h,
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.all(10.h),
                        child: BuildDefaultButton(
                          onTap: () {
                           if (formKey.currentState!.validate()) {
                             formKey.currentState!.save();
                              if (HelperFunctions.hasUserRegistered()) {
                                submit(
                                  addPostCubit: addPostCubit,
                                  context: context,
                                  title: addPostCubit.enteredTitle,
                                  description: addPostCubit.enteredDescription,
                                  price: addPostCubit.priceIndex == 0
                                      ? addPostCubit.enteredPrice
                                      : '0',
                                  educationLevel: addPostCubit.educationLevel,
                                  educationType:
                                      addPostCubit.enteredEducationType,
                                  grade: addPostCubit.enteredGrade,
                                  region: addPostCubit.enteredRegion,
                                  semester: addPostCubit.enteredSemester,
                                  bookEdition: addPostCubit.enteredBookEdition,
                                  booksCount: addPostCubit.enteredBooksCount,
                                  locale: locale,
                                );
                              } else {
                                // buildToastMessage(
                                //   message: locale.go_register_message,
                                //   gravity: ToastGravity.CENTER,
                                // );
                              }
                            }
                          },
                          text: locale.submit,
                          color: ColorConstant.primaryColor,
                          elevation: 3,
                          context: context,
                          withBorder: false,
                        ),
                      ),
                    ),
                  ),
            appBar: AppBar(
                toolbarHeight: 55.h,
                leading: Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: BuildBackIcon(
                      backX: true,
                      onTap: () {
                        showPopUp(
                          context: context,
                          textTitle: locale.cancel,
                          textOk: locale.ok,
                          textCenter: locale.cancelAddPost,
                          onPress: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            addPostCubit.selectedImages=[];
                            addPostCubit.resetData();

                          },
                        );
                      }),
                ),
                centerTitle: true,
                title: Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Text(
                    locale.addPost,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                )),
            body: Container(
              padding: EdgeInsets.all(20.h),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        addPostCubit.pickImages(context, locale.choose_only_5);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorConstant.blackColor.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(12.r),
                          color: ColorConstant.lightGreyColor,
                        ),
                        child: addPostCubit.selectedImages.isNotEmpty
                            ? Wrap(
                                clipBehavior: Clip.hardEdge,
                                alignment: WrapAlignment.center,
                                children: List.generate(
                                  addPostCubit.selectedImages.length,
                                  (index) => Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.6,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 6.w, vertical: 6.h),
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Image.file(
                                      addPostCubit.selectedImages[index],
                                      fit: BoxFit.cover,
                                      width: 100.w,
                                      height: 100.h,
                                    ),
                                  ),
                                ),
                              )
                            : Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    SolarIconsOutline.uploadMinimalistic,
                                    color: ColorConstant.primaryColor,
                                    size: 30.h,
                                  ),
                                  Text(
                                    locale.upload_images,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    Text(
                      locale.maximum_images,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 11.sp,
                            color: Theme.of(context).shadowColor,
                          ),
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BuildDropDownButton(
                            icon: SolarIconsOutline.mapPoint,
                            dropDownHint: locale.your_city,
                            items: regionsDropDownItems.keys.toList(),
                            text: '',
                            errorMessage: locale.city_error_message,
                            onSelect: (value) {
                              addPostCubit
                                  .changeRegion(regionsDropDownItems[value]!);
                            },
                            onSave: (value) {
                              addPostCubit
                                  .changeRegion(regionsDropDownItems[value]!);
                            },
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          BuildRowAboveOptions(text: locale.post_title),
                          SizedBox(
                            height: 4.h,
                          ),
                          BuildDefaultTextField(
                            inputType: TextInputType.text,
                            withText: false,
                            hintText: locale.title_hint,
                            backGroundColor: ColorConstant.whiteColor,
                            context: context,
                            width: double.infinity,
                            height: 50.h,
                            maxLenght: 35,
                            isObscured: false,
                            onChange: (value) {
                              addPostCubit.changeTitle(value);
                            },
                            onSaved: (value) {
                              if (value != null) {
                                addPostCubit.changeTitle(value);
                              }
                            },
                            onValidate: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return locale.title_error_message;
                              }
                              if (value.trim().length < 5) {
                                return locale.title_error_message_2;
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          BuildRowAboveOptions(text: locale.post_description),
                          SizedBox(
                            height: 4.h,
                          ),
                          BuildDefaultTextField(
                            inputType: TextInputType.text,
                            withText: false,
                            hintText: locale.description_hint,
                            backGroundColor: ColorConstant.whiteColor,
                            context: context,
                            width: double.infinity,
                            height: 150.h,
                            maxLenght: 1000,
                            maxLines: 8,
                            isObscured: false,
                            onSaved: (value) {
                              addPostCubit.changeDescription(value!);
                            },
                            onValidate: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return locale.description_error_message;
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          BuildRowAboveOptions(text: locale.education_level),
                          SizedBox(
                            height: 8.h,
                          ),
                          Wrap(
                            alignment: WrapAlignment.start,
                            runAlignment: WrapAlignment.start,
                            spacing: 16.w,
                            runSpacing: 12.w,
                            children: List.generate(
                              5,
                              (index) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: ColorConstant.whiteColor,
                                  border: addPostCubit.levelIndex == index
                                      ? Border.all(
                                          width: 2,
                                          color: ColorConstant.primaryColor)
                                      : null,
                                ),
                                child: BuildOptionButton(
                                  onTap: () {
                                    if (index == 0 || index == 1) {
                                      addPostCubit.enteredGrade = '';
                                      addPostCubit.gradeIndex = null;
                                    }

                                    addPostCubit.changeEducationLevel(
                                      educationLevels.values.toList()[index],
                                      index,
                                    );
                                  },
                                  text: educationLevels.keys.toList()[index],

                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          BuildRowAboveOptions(text: locale.price),
                          SizedBox(
                            height: 4.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: [
                              BuildDefaultTextField(
                                controller: priceTextEditingController,
                                isEnabled: addPostCubit.priceIndex == 0,
                                onChange: (value) {
                                  addPostCubit.changePrice(value);
                                },
                                inputType: TextInputType.number,
                                withText: false,
                                hintText: addPostCubit.priceIndex == 1
                                    ? '0 ${locale.egp}'
                                    : '',
                                backGroundColor: ColorConstant.whiteColor,
                                context: context,
                                width: MediaQuery.of(context).size.width / 3,
                                height: 50.h,
                                maxLenght: 5,
                                isObscured: false,
                                onSaved: (value) {
                                  addPostCubit.changePrice(value!);
                                },
                                onValidate: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty &&
                                          addPostCubit.priceIndex == 0) {
                                    return locale.price_error_message;
                                  } else if (!checkPrice(
                                        numberOfBooks:
                                            addPostCubit.enteredBooksCount,
                                        bookPrice: addPostCubit.enteredPrice,
                                      ) &&
                                      addPostCubit.priceIndex == 0 &&
                                      addPostCubit.educationLevel !=
                                          levels[4]) {
                                    return '';
                                  }
                                  return null;
                                },
                              ),
                              Text(locale.or),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                height: 40.h,
                                child: Container(
                                  decoration: addPostCubit.priceIndex == 1
                                      ? BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              width: 2,
                                              color: Theme.of(context).primaryColor))
                                      : null,
                                  child: BuildDefaultButton(
                                    onTap: () {
                                      if (addPostCubit.priceIndex == 0) {
                                        priceTextEditingController.clear();
                                        addPostCubit.togglePriceButton(1);
                                      } else {
                                        addPostCubit.togglePriceButton(0);
                                      }
                                    },
                                    text: locale.free,
                                    color: ColorConstant.primaryColor,
                                    elevation: 1,
                                    context: context,
                                    withBorder: false,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          if (!checkPrice(
                                numberOfBooks: addPostCubit.enteredBooksCount,
                                bookPrice: addPostCubit.enteredPrice,
                              ) &&
                              addPostCubit.priceIndex == 0 &&
                              addPostCubit.educationLevel != levels[4])
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Text(
                                locale.overpriced_message,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: ColorConstant.dangerColor,
                                        fontSize: 12.sp),
                              ),
                            ),
                          SizedBox(
                            height: 16.h,
                          ),
                          BuildRowAboveOptions(text: locale.books_count),
                          SizedBox(
                            height: 4.h,
                          ),
                          BuildDefaultTextField(
                            inputType: TextInputType.number,
                            withText: false,
                            hintText: '',
                            backGroundColor: ColorConstant.whiteColor,
                            context: context,
                            width: 130.w,
                            height: 50.h,
                            maxLenght: 3,
                            isObscured: false,
                            onChange: (value) {
                              addPostCubit.changeBooksCount(value);
                            },
                            onSaved: (value) {
                              addPostCubit.changeBooksCount(value!);
                            },
                            onValidate: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return locale.books_count_error_message;
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          BuildRowAboveOptions(
                            text: locale.grade,
                            optional: true,
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          addPostCubit.educationLevel ==
                                  educationLevels.values.toList()[0]
                              ? Wrap(
                                  alignment: WrapAlignment.start,
                                  runAlignment: WrapAlignment.start,
                                  spacing: 16.w,
                                  runSpacing: 12.w,
                                  children: List.generate(
                                    2,
                                    (index) => Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14.r),
                                        color:Theme.of(context).cardColor,
                                        border: addPostCubit.gradeIndex == index
                                            ? Border.all(
                                                width: 2,
                                                color:
                                                    ColorConstant.primaryColor)
                                            : null,
                                      ),
                                      width: MediaQuery.of(context).size.width /
                                          3.8,
                                      child: BuildOptionButton(
                                        onTap: () {
                                          if (addPostCubit.gradeIndex ==
                                              index) {
                                            addPostCubit.changeGrade('', null);
                                          } else {
                                            addPostCubit.changeGrade(
                                                grades.values.toList()[index],
                                                index);
                                          }
                                        },
                                        text: grades.keys.toList()[index],
                                      ),
                                    ),
                                  ),
                                )
                              : Wrap(
                                  alignment: WrapAlignment.start,
                                  runAlignment: WrapAlignment.start,
                                  spacing: 16.w,
                                  runSpacing: 12.w,
                                  children: addPostCubit.isPrimary
                                      ? List.generate(
                                          6,
                                          (index) => Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14.r),
                                              color: Theme.of(context).cardColor,
                                              border: addPostCubit.gradeIndex ==
                                                      index
                                                  ? Border.all(
                                                      width: 2,
                                                      color: ColorConstant
                                                          .primaryColor)
                                                  : null,
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.8,
                                            child: BuildOptionButton(
                                              onTap: () {
                                                if (addPostCubit.gradeIndex ==
                                                    index) {
                                                  addPostCubit.changeGrade(
                                                      '', null);
                                                } else {
                                                  addPostCubit.changeGrade(
                                                    grades.values
                                                        .toList()[index],
                                                    index,
                                                  );
                                                }
                                              },
                                              text: grades.keys.toList()[index],
                                            ),
                                          ),
                                        )
                                      : List.generate(
                                          3,
                                          (index) => Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14.r),
                                              color: Theme.of(context).cardColor,
                                              border: addPostCubit.gradeIndex ==
                                                      index
                                                  ? Border.all(
                                                      width: 2,
                                                      color: ColorConstant
                                                          .primaryColor)
                                                  : null,
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3.8,
                                            child: BuildOptionButton(
                                              onTap: () {
                                                if (addPostCubit.gradeIndex ==
                                                    index) {
                                                  addPostCubit.changeGrade(
                                                      '', null);
                                                } else {
                                                  addPostCubit.changeGrade(
                                                    grades.values
                                                        .toList()[index],
                                                    index,
                                                  );
                                                }
                                              },
                                              text: grades.keys.toList()[index],
                                            ),
                                          ),
                                        ),
                                ),
                          SizedBox(
                            height: 16.h,
                          ),
                          BuildRowAboveOptions(
                            text: locale.education_type,
                            optional: true,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Wrap(
                            alignment: WrapAlignment.start,
                            runAlignment: WrapAlignment.start,
                            spacing: 16.w,
                            runSpacing: 12.w,
                            children: List.generate(
                              3,
                              (index) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.r),
                                  color: Theme.of(context).cardColor,
                                  border: addPostCubit.typeIndex == index
                                      ? Border.all(
                                          width: 2,
                                          color: ColorConstant.primaryColor,
                                        )
                                      : null,
                                ),
                                child: BuildOptionButton(
                                  onTap: () {
                                    if (addPostCubit.typeIndex == index) {
                                      addPostCubit.changeEducationType(
                                        '',
                                        null,
                                      );
                                    } else {
                                      addPostCubit.changeEducationType(
                                        educationTypes.values.toList()[index],
                                        index,
                                      );
                                    }
                                  },
                                  text: educationTypes.keys.toList()[index],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          BuildRowAboveOptions(
                            text: locale.term,
                            optional: true,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Wrap(
                            alignment: WrapAlignment.start,
                            runAlignment: WrapAlignment.start,
                            spacing: 16.w,
                            runSpacing: 12.w,
                            children: List.generate(
                              3,
                              (index) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.r),
                                  color: Theme.of(context).cardColor,
                                  border: addPostCubit.semesterIndex == index
                                      ? Border.all(
                                          width: 2,
                                          color: ColorConstant.primaryColor)
                                      : null,
                                ),
                                child: BuildOptionButton(
                                  onTap: () {
                                    if (addPostCubit.semesterIndex == index) {
                                      addPostCubit.changeSemester(
                                        '',
                                        null,
                                      );
                                    } else {
                                      addPostCubit.changeSemester(
                                        semesters.values.toList()[index],
                                        index,
                                      );
                                    }
                                  },
                                  text: semesters.keys.toList()[index],
                                ),
                              ),
                            ),
                          ),
                          BuildDropDownButton(
                            optional: true,
                            errorMessage: locale.edition_error_message,
                            dropDownHint: locale.your_book_edition,
                            items: addPostCubit.yearsDropDownItems,
                            text: locale.education_year,
                            onSelect: (value) {
                              if (value != null) {
                                addPostCubit.changeBookEdition(value);
                              }
                            },
                            onSave: (value) {
                              addPostCubit.changeBookEdition(value ?? '');
                            },
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 74.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void submit(
      {required AddPostCubit addPostCubit,
      required BuildContext context,
      required String title,
      required String description,
      required String price,
      required String educationLevel,
      required String educationType,
      required String grade,
      required String region,
      required String semester,
      required String bookEdition,
      required String booksCount,
      required AppLocalizations locale}) {
    if (addPostCubit.selectedImages.isEmpty) {
      buildDialogue(
          context: context,
          message: 'Please Select Your Images');
      return;
    }

    if (addPostCubit.levelIndex == null) {
      snackBarMessage(
        context: context,
        message: locale.choose_level,
        snackbarState: SnackbarState.error,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // print('title $title');
    // print('description $description');
    // print('grade $grade');
    // print('educationlevel $educationLevel');
    // print('semester $semester');
    // print('educationtype $educationType');
    // print('booksCount $booksCount');
    // print('region $region');
    // print('price $price');
    // print('bookEdition $bookEdition');

    addPostCubit.sendNewPost(
      title: title,
      description: description,
      price: price,
      educationLevel: educationLevel,
      educationType: educationType,
      grade: grade,
      cityLocation: region,
      semester: semester,
      images: addPostCubit.selectedImages,
      bookEdition: bookEdition,
      numberOfBooks: booksCount,
      context: context,
      noInternet: locale.no_internet,
      weakInternet: locale.weak_internet,
      token: CacheHelper.getData(key: AppConstant.token),
    );
  }

  bool checkPrice({required String numberOfBooks, required String bookPrice}) {
    int? number = int.tryParse(numberOfBooks);

    int? price = int.tryParse(bookPrice) ?? 1;

    var limit = 0;
    if (number != null) {
      limit = number * 45;
    }
    return price <= limit;
  }
}
