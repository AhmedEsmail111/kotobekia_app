import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/category_details/category_details_cubit.dart';
import 'package:kotobekia/controller/chat/chat_cubit.dart';
import 'package:kotobekia/controller/user_ads/user_ads_cubit.dart';
import 'package:kotobekia/modules/create_account/create_account_screen.dart';
import 'package:kotobekia/modules/message_screen/message_screen.dart';
import 'package:kotobekia/modules/view_profile/view_profile_screen.dart';
import 'package:kotobekia/shared/component/navigation.dart';
import 'package:kotobekia/shared/component/vertical_divider.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/constants/images/images_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:kotobekia/shared/styles/colors.dart';
import 'package:solar_icons/solar_icons.dart';

class BuildContactCard extends StatelessWidget {
  final String name;
  final bool male;
  final String receiverId;
  final bool viewProfile;
  final bool isVerified;
  final String titlePost;
  final String categoryPost;
  final dynamic price;
  final String emailOrPhone;
  final String image;

  const BuildContactCard(
      {super.key,
      required this.male,
      required this.emailOrPhone,
      required this.image,
      required this.name,
      required this.price,
      required this.categoryPost,
      required this.titlePost,
      required this.isVerified,
       this.viewProfile=true,
      required this.receiverId});

  @override
  Widget build(BuildContext context) {
    // Define a delay duration
    const Duration debounceDuration = Duration(milliseconds: 500);

// Create a timer variable
    Timer? _debounceTimer;
    final locale = AppLocalizations.of(context);
    return BlocConsumer<ChatCubit, ChatState>(listener: (ctx, state) {
      if (state is SuccessOpenUserConversationState) {
       pushWithAnimationLeftAndBottom(context: context,
           widget: MessageScreen(
           //   image: image,
           // titlePost: titlePost,
           // price: price.toString(),
           // categoryPost: categoryPost,
           reciveId: state.conversationTwoUserModel.receiverId!,
           convId: state.conversationTwoUserModel.sId!,
           name: name,
           male: male));
      }
    }, builder: (ctx, state) {
      var cubit = context.read<ChatCubit>();
      return Container(
        padding: EdgeInsets.all(8.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(12.r),
          color: Theme.of(context).cardColor,
        ),
        width: double.infinity,
        height: 100.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(!isEmail(emailOrPhone))
                  TextButton.icon(
                    onPressed: () {
                      if(CacheHelper.getData(key: AppConstant.token)!=null) {
                        CategoryDetailsCubit.get(context).handleCall(emailOrPhone);
                      }else{
                        Navigator.pushNamed(context, 'getStart');
                      }
                    },
                    label: Text(
                      locale.call,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 14.sp,
                          ),
                    ),
                    icon: Icon(
                      SolarIconsOutline.phoneRounded,
                      color: ColorConstant.primaryColor,
                      size: 18.w,
                    )),

                TextButton.icon(
                  onPressed: ()  {
                    if(CacheHelper.getData(key: AppConstant.token)!=null) {
                      _debounceTimer?.cancel();

                      // Start a new timer
                      _debounceTimer = Timer(debounceDuration, () {
                        cubit.openUserConversation(
                            token: CacheHelper.getData(key: AppConstant.token), receiverId: receiverId);
                      });

                    }else{
                      Navigator.pushNamed(context, 'getStart');
                    }
                  },
                  label: Text(
                    locale.chat,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  icon: Icon(
                    SolarIconsOutline.letter,
                    color: ColorConstant.secondaryColor,
                    size: 18.w,
                  ),
                ),
              ],
            ),
            SizedBox(width: 10.w,),
            const BuildVerticalDivider(
              height: double.infinity,
            ),
            SizedBox(width: 10.w,),
            SizedBox(
              width: 60.w,
              height: 60.w,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircleAvatar(
                    backgroundColor: ColorConstant.whiteColor,
                    child: Image.asset(
                     male?
                      ImageConstant.userMaleImage:
                     ImageConstant.userFemaleImage,
                      fit: BoxFit.cover,
                      width: 70.h,
                      height: 70.h,
                    ),
                  ),
                  if(isVerified)
                    const Positioned(
                    right: 0,
                    bottom: 0,
                    child: Icon(
                      SolarIconsBold.verifiedCheck,
                      color: Color(0xFF08B1E7),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 140.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  if(viewProfile)
                    GestureDetector(
                    onTap: () {
                    pushWithAnimationLeftAndBottom(
                      left: false,
                        context: context,
                        widget: ViewProfileScreen(
                            name: name,
                            male: male));
                     print(receiverId);
                     UserAddsCubit.get(context).getUserPost(recieverId: receiverId);
                    },
                    child: Text(
                      locale.view_profile,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 10.sp,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
