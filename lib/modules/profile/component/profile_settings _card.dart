// ignore: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kotobekia/controller/authentication/authentication_cubit.dart';
import 'package:kotobekia/controller/home/home_cubit.dart';
import 'package:kotobekia/controller/language/language_cubit.dart';
import 'package:kotobekia/controller/profile/profile_cubit.dart';
import 'package:kotobekia/controller/profile/profile_states.dart';
import 'package:kotobekia/modules/help/help_screen.dart';
import 'package:kotobekia/modules/profile/component/profile_tile.dart';
import 'package:kotobekia/shared/component/choose_language.dart';
import 'package:kotobekia/shared/component/default_button_in_app.dart';
import 'package:kotobekia/shared/component/divider_line.dart';
import 'package:kotobekia/shared/component/toast_message.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/helper/functions.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:kotobekia/shared/styles/colors.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class BuildProfileSettingsCard extends StatelessWidget {
  const BuildProfileSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    void launchGmail() async {
      String? encodeQueryParameters(Map<String, String> params) {
        return params.entries
            .map((MapEntry<String, String> e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
            .join('&');
      }

// ···
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'kotobekia@gmail.com',
        query: encodeQueryParameters(<String, String>{
          'subject': 'Problem in Kotobekia',
        }),
      );

      launchUrl(emailLaunchUri);
    }

    return BlocConsumer<ProfileCubit, ProfileStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Card(
            color: Theme.of(context).cardColor,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Theme.of(context).cardColor,
              ),
              child: Column(
                children: [
                  if (ProfileCubit.get(context)
                          .userDataModel
                          ?.user
                          ?.birthDate !=
                      null)
                    BuildProfileTile(
                      icon: SolarIconsOutline.user,
                      text: locale.modify_profile,
                      withSwitchIcon: false,
                      iconColor: Theme.of(context).iconTheme.color!,
                      onClick: () {
                        if (HelperFunctions.hasUserRegistered()) {
                          Navigator.pushNamed(context, 'modifyProfile');
                        } else {
                          buildToastMessage(
                              message: locale.go_register_message,
                              gravity: ToastGravity.CENTER);
                        }
                      },
                    ),
                  if (ProfileCubit.get(context)
                          .userDataModel
                          ?.user
                          ?.birthDate !=
                      null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: const BuildDividerLine(
                        thickness: 2,
                      ),
                    ),
                  BuildProfileTile(
                    icon: SolarIconsOutline.heart,
                    iconColor: Theme.of(context).iconTheme.color!,
                    text: locale.favorite_adds,
                    withSwitchIcon: false,
                    onClick: () {
                      if (HelperFunctions.hasUserRegistered()) {
                        Navigator.pushNamed(context, 'favoriteAdds');
                      } else {
                        buildToastMessage(
                            message: locale.go_register_message,
                            gravity: ToastGravity.CENTER);
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: const BuildDividerLine(
                      thickness: 2,
                    ),
                  ),
                  BuildProfileTile(
                    icon: SolarIconsOutline.textSquare,
                    iconColor: Theme.of(context).iconTheme.color!,
                    text: locale.language,
                    withSwitchIcon: false,
                    onClick: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: false,
                        useSafeArea: true,
                        builder: (BuildContext context) {
                          // Return a widget that represents the contents of the bottom sheet
                          return SizedBox(
                              height: 320.h,
                              child: Padding(
                                padding: EdgeInsets.all(12.h),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 6.h,
                                      width: 70.w,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Icon(
                                            Icons.close,
                                            size: 25.r,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          locale.chooseLanguage,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          locale.whatIsFavouriteLang,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    const BuildChooseLanguage(),
                                    SizedBox(
                                      height: 32.h,
                                    ),
                                    BuildDefaultButton(
                                        onTap: () {
                                          LanguageCubit.get(context)
                                              .setDefaultLanguage();
                                          HomeCubit.get(context)
                                              .changeBottomNavBarIndex(
                                                  0, context);
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            'homeLayout',
                                            (Route<dynamic> route) => false,
                                          );
                                        },
                                        text: locale.continue1,
                                        color: ColorConstant.primaryColor,
                                        elevation: 2,
                                        context: context)
                                  ],
                                ),
                              ));
                        },
                      ).then((value) {
                        LanguageCubit.get(context).index =
                            CacheHelper.getData(key: AppConstant.languageKey) ==
                                    'ar'
                                ? 1
                                : 0;
                      });
                      //Navigator.pushNamed(context, 'changeLanguage');
                    },
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 16.w),
                  //   child: const BuildDividerLine(
                  //     thickness: 2,
                  //   ),
                  // ),
                  // BuildProfileTile(
                  //   icon: SolarIconsOutline.sun,
                  //   iconColor: Theme.of(context).iconTheme.color!,
                  //   text: locale.dark_mode,
                  //   withSwitchIcon: true,
                  //   switchStatus: ProfileCubit.get(context).isDarkMode,
                  //   onClick: ProfileCubit.get(context).toggleDarkMode,
                  // ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: const BuildDividerLine(
                      thickness: 2,
                    ),
                  ),
                  BuildProfileTile(
                    icon: SolarIconsOutline.infoSquare,
                    iconColor: ColorConstant.primaryColor,
                    text: locale.help,
                    withSwitchIcon: false,
                    onClick: () {
                      Navigator.pushNamed(context, 'help');
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: const BuildDividerLine(
                      thickness: 2,
                    ),
                  ),
                  BuildProfileTile(
                    icon: SolarIconsOutline.shieldWarning,
                    iconColor: ColorConstant.primaryColor,
                    text: locale.report_problem,
                    withSwitchIcon: false,
                    onClick: () {
                      launchGmail();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}
