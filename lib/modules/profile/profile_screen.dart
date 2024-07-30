import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/authentication/authentication_cubit.dart';
import 'package:kotobekia/controller/chat/chat_cubit.dart';
import 'package:kotobekia/controller/favorites/favorites_cubit.dart';
import 'package:kotobekia/controller/home/home_cubit.dart';
import 'package:kotobekia/controller/internet/internet-states.dart';
import 'package:kotobekia/controller/internet/internet_cubit.dart';
import 'package:kotobekia/controller/notification/notification_cubit.dart';
import 'package:kotobekia/controller/profile/profile_cubit.dart';
import 'package:kotobekia/controller/profile/profile_states.dart';
import 'package:kotobekia/controller/user_ads/user_ads_cubit.dart';
import 'package:kotobekia/modules/profile/component/no_account_placeholder.dart';
import 'package:kotobekia/modules/profile/component/profile_settings%20_card.dart';
import 'package:kotobekia/modules/profile/component/profile_tile.dart';
import 'package:kotobekia/modules/profile/component/user_info_card.dart';
import 'package:kotobekia/shared/component/general_pop_up.dart';
import 'package:kotobekia/shared/component/no_internet.dart';
import 'package:kotobekia/shared/component/shimmer_loading.dart';
import 'package:kotobekia/shared/component/snakbar_message.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/constants/images/images_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:kotobekia/shared/styles/colors.dart';
import 'package:solar_icons/solar_icons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (ProfileCubit.get(context).userDataModel == null) {
      ProfileCubit.get(context)
          .setUser(CacheHelper.getData(key: AppConstant.token));
      ProfileCubit.get(context).getUser();
    }
    final locale = AppLocalizations.of(context);
    return BlocBuilder<InternetCubit, InternetStates>(
      builder: (context, internetState) {
        return internetState is InternetNotConnected ||
            !InternetCubit.get(context).isDeviceConnected
            ? const BuildNoInternet():
        BlocConsumer<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state is SuccessChangePasswordState) {
              snackBarMessage(
                  context: context,
                  displayBottom: false,
                  inHome: true,
                  message: locale.changePasswordSuccess,
                  snackbarState: SnackbarState.success,
                  duration: const Duration(seconds: 3));
            }
          },
          builder: (context, state) {
            return WillPopScope(
              onWillPop: () async {
                Navigator.pushReplacementNamed(context, 'homeLayout');
                HomeCubit.get(context).changeBottomNavBarIndex(0, context);
                return true;
              },
              child: BlocBuilder<ProfileCubit, ProfileStates>(
                builder: (context, state) {
                  final profileCubit = context.read<ProfileCubit>();
                  return profileCubit.userDataModel != null ||
                          (CacheHelper.getData(key: AppConstant.token) ==
                                  null &&
                              profileCubit.userDataModel == null)
                      ? SingleChildScrollView(
                              child: SafeArea(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 20.h,
                                      bottom: 16.h,
                                      left: 16.w,
                                      right: 16.w),
                                  child: Column(
                                    children: [
                                      if (!profileCubit.hasAccount)
                                        const NoAccountPlaceholder(),
                                      if (profileCubit.hasAccount)
                                        Text(
                                          locale.account,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      SizedBox(
                                        height: 35.h,
                                      ),
                                      if (profileCubit.hasAccount)
                                        Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            Image.asset(
                                              ProfileCubit.get(context).userDataModel!.user!.gender=='male'?
                                              ImageConstant.userMaleImage:ImageConstant.userFemaleImage,width: 90.w,height: 90.h,),
                                            if (profileCubit.userDataModel!
                                                .user!.isVerified!&&profileCubit.userDataModel!
                                                .user!.isVerified!=null)
                                              Positioned(
                                                right: 1.5.w,
                                                child: Icon(
                                                  SolarIconsBold.verifiedCheck,
                                                  size: 28.w,
                                                  color: const Color(0xFF08B1E7),
                                                ),
                                              )
                                          ],
                                        ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      if (profileCubit.hasAccount)
                                        Text(
                                          profileCubit
                                              .userDataModel!.user!.fullName!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.w400,
                                              ),
                                        ),
                                      SizedBox(
                                        height: 4.h,
                                      ),
                                      if (profileCubit.hasAccount)
                                        Text(
                                          profileCubit
                                                  .userDataModel!.user!.email ??
                                              profileCubit.userDataModel!.user!
                                                  .phoneNumber!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12.sp),
                                        ),
                                      SizedBox(
                                        height: 16.h,
                                      ),
                                      if (profileCubit.hasAccount)
                                        const BuildUserInfoCard(),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      const BuildProfileSettingsCard(),
                                      SizedBox(
                                        height: 12.h,
                                      ),
                                      if (profileCubit.hasAccount)
                                        Card(
                                          color: Theme.of(context).cardColor,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(14.r)),
                                            child: BuildProfileTile(
                                              icon: SolarIconsOutline.logout_2,
                                              iconColor:
                                                  ColorConstant.dangerColor,
                                              text: locale.log_out,
                                              withSwitchIcon: false,
                                              onClick: () {
                                                showPopUp(
                                                    textTitle: locale.signOut,
                                                    onPress: () {
                                                      FavoritesCubit.get(
                                                              context)
                                                          .favPostsModel = null;
                                                      HomeCubit.get(context)
                                                          .getHomePosts(
                                                              noInternet: locale
                                                                  .no_internet,
                                                              weakInternet: locale
                                                                  .weak_internet);
                                                      ProfileCubit.get(context)
                                                          .userDataModel = null;
                                                      UserAddsCubit.get(context).userAdsModel=null;
                                                      ChatCubit.get(context)
                                                          .socket!
                                                          .dispose();
                                                      ChatCubit.get(context)
                                                              .conversationTwoUserModel =
                                                          null;
                                                      ChatCubit.get(context)
                                                              .conversationModel =
                                                          null;
                                                      NotificationCubit.get(
                                                                  context)
                                                              .notificationModel =
                                                          null;
                                                      profileCubit.signOut();
                                                      Navigator.pop(context);
                                                    },
                                                    context: context,
                                                    textOk: locale.signOut,
                                                    textCenter:
                                                        locale.sureToSignOut);
                                              },
                                            ),
                                          ),
                                        ),
                                      SizedBox(
                                        height: 28.h,
                                      ),
                                      if (profileCubit.hasAccount)
                                        Card(
                                          color: Theme.of(context).cardColor,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).cardColor,
                                                borderRadius:
                                                    BorderRadius.circular(14)),
                                            child: BuildProfileTile(
                                              icon:
                                                  CupertinoIcons.delete_simple,
                                              iconColor:
                                                  ColorConstant.dangerColor,
                                              text: locale.deleteAccount,
                                              withSwitchIcon: false,
                                              onClick: () {
                                                showPopUp(
                                                    textTitle:
                                                        locale.deleteAccount,
                                                    onPress: () {
                                                      AuthenticationCubit.get(
                                                              context)
                                                          .deleteAccount(
                                                              token: CacheHelper
                                                                  .getData(
                                                                      key: AppConstant
                                                                          .token),
                                                              id: CacheHelper.getData(
                                                                  key: AppConstant
                                                                      .userId));
                                                      FavoritesCubit.get(
                                                              context)
                                                          .favPostsModel = null;
                                                      HomeCubit.get(context)
                                                          .getHomePosts(
                                                              noInternet: locale
                                                                  .no_internet,
                                                              weakInternet: locale
                                                                  .weak_internet);
                                                      ProfileCubit.get(context)
                                                          .userDataModel = null;
                                                      UserAddsCubit.get(context).userAdsModel=null;

                                                      ChatCubit.get(context)
                                                          .socket!
                                                          .dispose();
                                                      ChatCubit.get(context)
                                                              .conversationTwoUserModel =
                                                          null;
                                                      ChatCubit.get(context)
                                                              .conversationModel =
                                                          null;
                                                      NotificationCubit.get(
                                                                  context)
                                                              .notificationModel =
                                                          null;
                                                      profileCubit.signOut();
                                                      Navigator.pop(context);
                                                    },
                                                    context: context,
                                                    textOk:
                                                        locale.deleteAccount,
                                                    textCenter: locale
                                                        .sureToDeleteAccount);
                                              },
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            )
                      : SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(14.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 90.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleSkeleton(size: 85.r),
                                ],
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              Skeleton(height: 20.h, width: 120.w),
                              SizedBox(
                                height: 10.h,
                              ),
                              Skeleton(height: 12.h, width: 180.w),
                              SizedBox(
                                height: 15.h,
                              ),
                              Skeleton(height: 60.h, width: double.infinity),
                              SizedBox(
                                height: 12.h,
                              ),
                              Skeleton(height: 200.h, width: double.infinity),
                              SizedBox(
                                height: 10.h,
                              ),
                              Skeleton(height: 35.h, width: double.infinity),
                              SizedBox(
                                height: 14.h,
                              ),
                              Skeleton(height: 35.h, width: double.infinity),
                            ],
                          ),
                        ),
                      );
                },
              ),
            );
          },
        );
      },
    );
  }
}
