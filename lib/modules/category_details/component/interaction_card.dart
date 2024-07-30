import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/category_details/category_details_cubit.dart';
import 'package:kotobekia/controller/category_details/category_details_states.dart';
import 'package:kotobekia/controller/favorites/favorites_cubit.dart';
import 'package:kotobekia/controller/favorites/favorites_states.dart';
import 'package:kotobekia/shared/component/report_pop_up.dart';
import 'package:kotobekia/shared/component/small_loading_indicator.dart';
import 'package:kotobekia/shared/helper/functions.dart';
import 'package:kotobekia/shared/styles/colors.dart';
import 'package:solar_icons/solar_icons.dart';

class BuildInteractionCard extends StatelessWidget {
  final String postId;
  final String userId;

  const BuildInteractionCard({
    super.key,
    required this.postId,
    required this.userId,
  });

  @override

  Widget build(BuildContext context) {
    const Duration debounceDuration = Duration(milliseconds: 500);

// Create a timer variable
    Timer? _debounceTimer;
    final locale = AppLocalizations.of(context);
    return BlocBuilder<CategoryDetailsCubit, CategoryDetailsStates>(
      builder: (ctx, state) {
        return Container(
          height: 100.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: ColorConstant.foregroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 11.w),
                child: Text(
                  'Ad id #1256',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: const Color(0xFF939393), fontSize: 10.sp),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BlocBuilder<FavoritesCubit, FavoritesStates>(
                    builder: (context, state) {
                      final cubit = FavoritesCubit.get(context);

                      return TextButton.icon(
                        label: Text(
                          locale.save,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        icon:state is! GetFavPostsSuccessState
                            &&cubit.favPostsModel!=null
                            ? const BuildSmallLoadingIndicator()
                            : Icon(
                                cubit.check
                                    ? SolarIconsBold.heart
                                    : SolarIconsOutline.heart,
                                color: cubit.check
                                    ? ColorConstant.dangerColor
                                    : Colors.black,
                                size: 20.w,
                              ),
                        onPressed: () {
                          if (HelperFunctions.hasUserRegistered()) {
                            if (cubit.check) {
                              cubit.removeFromFavorites(postId);
                            } else {
                              cubit.addToFavorites(postId);
                            }
                          } else {
                            Navigator.pushNamed(context, 'getStart');
                          }
                        },
                      );
                    },
                  ),
                  TextButton.icon(
                    onPressed: () {

                      if(HelperFunctions.hasUserRegistered()) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AnimatedBuilder(
                              animation: ModalRoute.of(context)!.animation!,
                              builder: (context, child) =>
                                  FadeTransition(
                                    opacity: ModalRoute.of(context)!.animation!,
                                    child: BuildReportPopUp(
                                      userId: userId,
                                      postId: postId,
                                      postType: 'post',
                                    ),
                                  ),
                            );
                          },
                        );
                      }else{
                        Navigator.pushNamed(context, 'getStart');
                      }
                    },
                    label: Text(
                      locale.report,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    icon: Icon(
                      SolarIconsBold.shieldUser,
                      size: 20.w,
                      color: ColorConstant.iconColor,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // Define a delay duration

                      _debounceTimer?.cancel();

                      // Start a new timer
                      _debounceTimer = Timer(debounceDuration, () {
                        CategoryDetailsCubit.get(ctx).sharePost(postId);
                      });
                    },
                    label: Text(
                      locale.share,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    icon: Icon(
                      SolarIconsBold.forward,
                      size: 20.w,
                      color: ColorConstant.iconColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
