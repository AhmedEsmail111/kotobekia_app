import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/user_ads/user_ads_cubit.dart';
import 'package:kotobekia/controller/user_ads/user_ads_states.dart';
import 'package:kotobekia/shared/component/back_icon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kotobekia/shared/component/loading_indicator.dart';
import 'package:kotobekia/shared/component/posts_grid.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/constants/images/images_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:kotobekia/shared/styles/colors.dart';

class ViewProfileScreen extends StatelessWidget {
  const ViewProfileScreen({
    super.key,
    required this.name,
    required this.male,
  });

  final String name;
  final bool male;

  @override
  Widget build(BuildContext context) {
    var cubit=context.read<UserAddsCubit>();
    var font = Theme
        .of(context)
        .textTheme;
    final locale = AppLocalizations.of(context);

    return BlocBuilder<UserAddsCubit, UserAddsStates>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async{
            Navigator.pop(context);
            cubit.userAdsModel=null;
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                locale!.profile,
                style: font.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              leading: BuildBackIcon(
                onTap: () {
                  Navigator.pop(context);
                  cubit.userAdsModel=null;
                },
              ),
            ),
            body:cubit.userAdsModel!=null?
            Padding(
              padding: EdgeInsets.all(10.h),
              child: Column(
                children: [
                  male
                      ? Center(
                    child: Image.asset(
                      ImageConstant.userMaleImage,
                      height: 120.h,
                      width: 120.w,
                    ),
                  )
                      : Center(
                      child: Image.asset(
                        ImageConstant.userFemaleImage,
                        height: 120.h,
                        width: 120.w,
                      )),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    name,
                    style: font.bodyLarge,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        locale.allAds,
                        style: font.bodyLarge!
                            .copyWith(color: ColorConstant.startingColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: CacheHelper.getData(key: AppConstant.languageKey)=='ar'?
                            95.w:
                        56.w,
                        height: 1.h,
                        color: ColorConstant.strieghtLineColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h,),
                  BuildPostsGrid(
                    viewProfile: false,
                    data: cubit.userAdsModel != null ?
                    cubit.userAdsModel!.posts : [],
                  ),
                ],
              ),
            ):
            const BuildLoadingIndicator()
            ,
          ),
        );
      },
    );
  }
}
