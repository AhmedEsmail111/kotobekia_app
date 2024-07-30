import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/category/category_cubit.dart';
import 'package:kotobekia/controller/category_details/category_details_cubit.dart';
import 'package:kotobekia/controller/category_details/category_details_states.dart';
import 'package:kotobekia/controller/chat/chat_cubit.dart';
import 'package:kotobekia/shared/component/report_pop_up.dart';
import 'package:kotobekia/shared/component/snakbar_message.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:kotobekia/shared/styles/colors.dart';
import 'package:solar_icons/solar_icons.dart';

import '../../../shared/constants/images/images_constant.dart';

class BuildUserRowInMessage extends StatelessWidget {
  final TextTheme font;
  final String name;
  final bool male;
  final ChatCubit chatCubit;
  final bool online;
  final String convId;
  final String recieverId;
  const BuildUserRowInMessage(
      {super.key, required this.font,
        required this.name,
        required this.recieverId,
        required this.convId,
         this.online=false,
        required this.chatCubit,
        required this.male});

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        GestureDetector(
            onTap: () {
              Navigator.pop(context);
              CacheHelper.removeData(key: AppConstant.convId);
              chatCubit.getUsersConversation(token:CacheHelper.getData(key: AppConstant.token));
              chatCubit.messages.clear();
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 28.w,
            )),
        SizedBox(width: 20.w,),
        Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Image.asset(
              male?ImageConstant.userMaleImage:
              ImageConstant.userFemaleImage,
              height: 45.h,
              width: 44.w,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 2.h, left: 2.w),
              child: CircleAvatar(
                radius: 5.r,
                backgroundColor: online?ColorConstant.primaryColor:Colors.grey,
              ),
            )
          ],
        ),
        const Spacer(),
        Column(
          children: [
            Text(
              name,
              style: font.titleMedium!.copyWith(fontSize: 16.sp),
            ),
          ],
        ),
        const Spacer(),
        BlocConsumer<CategoryDetailsCubit,CategoryDetailsStates>(
          listener: (context, state) {
            if(state is SuccessSendReportState){
              Navigator.pop(context);
              snackBarMessage(context: context,
                  displayBottom: false,
                  message: state.message,
                  snackbarState: SnackbarState.success,
                  duration: const Duration(seconds: 2));
            }else if(state is FailureSendReportState){
              Navigator.pop(context);
              snackBarMessage(context: context,
                  displayBottom: false,
                  message: state.error,
                  snackbarState: SnackbarState.error,
                  duration: const Duration(seconds: 2));
            }
          },
          builder: (context, state)=>GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AnimatedBuilder(
                    animation: ModalRoute.of(context)!.animation!,
                    builder: (context, child) =>FadeTransition(
                      opacity: ModalRoute.of(context)!.animation!,
                      child: BuildReportPopUp(
                        userId:recieverId ,
                        postId: convId,
                        postType: 'chat',
                      ),
                    ),
                  );
                },
              );
            },
            child: Icon(
              SolarIconsOutline.shieldUser,
              size: 28.w,
              color: ColorConstant.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
