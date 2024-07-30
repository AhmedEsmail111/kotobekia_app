import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/chat/chat_cubit.dart';
import 'package:kotobekia/controller/profile/profile_cubit.dart';
import 'package:kotobekia/controller/profile/profile_states.dart';
import 'package:kotobekia/shared/component/vertical_divider.dart';
import 'package:kotobekia/shared/styles/colors.dart';
import 'package:solar_icons/solar_icons.dart';

class BuildUserInfoCard extends StatelessWidget {
  const BuildUserInfoCard({super.key});
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return BlocBuilder<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        final profileCubit = ProfileCubit.get(context);
        return Card(
          color: Theme.of(context).cardColor,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Theme.of(context).cardColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      locale.number_of_chats,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 14.sp,
                          ),
                    ),
                    Text(
                      '${ChatCubit.get(context).otherUsers.length} ${locale.interaction}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF747474),
                          ),
                    ),
                  ],
                ),
                BuildVerticalDivider(
                  height: 45.h,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      locale.number_of_posts,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 14.sp,
                          ),
                    ),
                    Text(
                      profileCubit.userDataModel != null
                          ? '${profileCubit.userDataModel!.user!.yourAds!.length} ${locale.adds}'
                          : ' 0 ${locale.adds}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF747474),
                          ),
                    ),
                  ],
                ),
                if(profileCubit.userDataModel!.user!.badges!.isNotEmpty)
                  BuildVerticalDivider(
                  height: 45.h,
                ),
                if(profileCubit.userDataModel!.user!.badges!.isNotEmpty)
                  Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      locale.personal_badges,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 14.sp,
                          ),
                    ),
                    Wrap(
                      children: [
                       SizedBox(
                         height: 20.h,
                         child: ListView.separated(
                           shrinkWrap: true,
                           itemBuilder: (context, index) => Icon(
                             SolarIconsOutline.medalRibbonStar,
                             size: 18.w,
                           ),
                           separatorBuilder: (context, index) => SizedBox(width: 5.w,),
                           scrollDirection: Axis.horizontal,
                           itemCount: profileCubit.userDataModel!.user!.badges!.length,
                         ),
                       )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
