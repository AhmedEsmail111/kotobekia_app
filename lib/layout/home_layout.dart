import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/home/home_cubit.dart';
import 'package:kotobekia/controller/home/home_state.dart';
import 'package:kotobekia/modules/add_post/add_post_screen.dart';
import 'package:kotobekia/modules/get_start/get_start_screen.dart';
import 'package:kotobekia/shared/component/navigation.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:kotobekia/shared/styles/colors.dart';
import 'package:solar_icons/solar_icons.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final w = MediaQuery.of(context).size.width;
    final locale = AppLocalizations.of(context);

    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
      },
      builder: (context, state) {
        final homeCubit = HomeCubit.get(context);
        if ((homeCubit.currentIndex == 1 ||
                homeCubit.currentIndex == 2) &&
            CacheHelper.getData(key: AppConstant.token) == null) {
         return const GetStartScreen();
        }else {
          return  Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton:Padding(
              padding:  EdgeInsets.only(top: 22.h),
              child: SizedBox(
                width: 36.w,
                height: 38.w,
                child: FloatingActionButton(
                  foregroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    side: BorderSide(color:ColorConstant.primaryColor,width: 2.5.w)
                  ),
                  backgroundColor: Theme.of(context).cardColor,
                  onPressed: () {
                    if(CacheHelper.getData(key: AppConstant.token)!=null){
                      pushWithAnimationLeftAndBottom(context: context,
                          widget: const AddPostScreen(),left: false);
                    }else{
                      Navigator.pushNamed(context, 'getStart');
                    }
                  },
                  child:Icon(
                  Icons.add,
                    size: 22.h,
                    color: ColorConstant.primaryColor,
                  ),

                ),
              ),
            ) ,
            key: scaffoldKey,
            body: homeCubit.screens[homeCubit.currentIndex],
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Add shadow for depth
                    spreadRadius: 1,
                    blurRadius: 5.r,
                    offset: const Offset(0, 3), // Adjust shadow offset
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
                child: BottomNavigationBar(
                  showSelectedLabels: true,
                  elevation: 5,
                  currentIndex: homeCubit.currentIndex,
                  onTap: (index) {
                    homeCubit.changeBottomNavBarIndex(index,context);
                  },

                  items: [
                    BottomNavigationBarItem(
                      label: locale.home,
                      icon: const Icon(
                        SolarIconsOutline.home,
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: '${locale.my_posts}             ',
                      icon: Padding(
                        padding:  EdgeInsets.only(left:CacheHelper.getData(key: AppConstant.languageKey)=='ar' ?
                        38.w:0,right: CacheHelper.getData(key: AppConstant.languageKey)=='ar'?0:38.w),
                        child: const Icon(
                          SolarIconsOutline.widget_4,
                        ),
                      ),
                    ),

                    BottomNavigationBarItem(
                      label: '            ${locale.messages}',
                      icon: Padding(
                        padding:  EdgeInsets.only(left:CacheHelper.getData(key: AppConstant.languageKey)!='ar' ?
                        38.w:0,right: CacheHelper.getData(key: AppConstant.languageKey)!='ar'?0:38.w),
                        child: const Icon(SolarIconsOutline.letter),
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: locale.account,
                      icon: const Icon(
                        SolarIconsOutline.user,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          );
        }
      },
    );
  }
}
