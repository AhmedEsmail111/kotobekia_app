import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/home/home_cubit.dart';
import 'package:kotobekia/controller/internet/internet-states.dart';
import 'package:kotobekia/controller/internet/internet_cubit.dart';
import 'package:kotobekia/controller/user_ads/user_ads_cubit.dart';
import 'package:kotobekia/controller/user_ads/user_ads_states.dart';
import 'package:kotobekia/shared/component/no_internet.dart';
import 'package:kotobekia/shared/component/posts_grid.dart';
import 'package:kotobekia/shared/component/shimmer_loading.dart';
import 'package:solar_icons/solar_icons.dart';

class UserAdsScreen extends StatelessWidget {
  const UserAdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (UserAddsCubit
        .get(context)
        .userAdsModel == null) {
      UserAddsCubit.get(context).getUserPost();
    }
    final locale = AppLocalizations.of(context);
    final font = Theme
        .of(context)
        .textTheme;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, 'homeLayout');
        HomeCubit.get(context).changeBottomNavBarIndex(0, context);
        return true;
      },
      child: BlocBuilder<InternetCubit, InternetStates>(
        builder: (context, internetState) {
          return internetState is InternetNotConnected||!InternetCubit.get(context).isDeviceConnected?
          const BuildNoInternet()
              :BlocBuilder<UserAddsCubit, UserAddsStates>(
            builder: (context, state) {
              var userAdsCubit = UserAddsCubit.get(context);
              var userAdsModel = userAdsCubit.userAdsModel;
              return Scaffold(
                appBar: AppBar(
                  leading: Container(),
                  centerTitle: true,
                  title: Padding(
                    padding: EdgeInsets.only(top: 25.h),
                    child: Text(
                      locale.my_posts,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                body: userAdsModel != null ? SafeArea(
                  child: userAdsModel.posts.isEmpty ?
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(SolarIconsOutline.notebookBookmark, size: 45.w,
                          color: Colors.red,),
                        SizedBox(height: 20.h,),
                        Text(locale.have_no_post_message, style: font.bodyLarge!
                            .copyWith(fontSize: 15.sp),),
                        SizedBox(height: 5.h,),
                        Text(locale.createFirstBook, style: font.headlineMedium!
                            .copyWith(color: Colors.grey, fontSize: 17.sp),),
                      ],),
                  )
                      : Column(
                                          children: [
                      SizedBox(
                        height: 20.h,
                      ),
                        Expanded(
                          child: BuildPostsGrid(
                            data: userAdsModel.posts,
                          ),
                        ),
                                          ],
                                        ),
                ) :
                RefreshIndicator(
                  onRefresh: () async{
                    UserAddsCubit.get(context).getUserPost();
                  },
                  child: Padding(
                    padding:  EdgeInsets.only(top:20.h),
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 270.h
                      ),
                      physics: const BouncingScrollPhysics(),
                      itemCount: 6,
                      itemBuilder: (ctx, index) {
                        return Card(
                            elevation: 0.1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r)
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(6.h),
                              child: const BuildBookShimmer(),
                            ));
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
