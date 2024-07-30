import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/chat/chat_cubit.dart';
import 'package:kotobekia/controller/internet/internet-states.dart';
import 'package:kotobekia/controller/internet/internet_cubit.dart';
import 'package:kotobekia/modules/message_screen/component/item_for_user_in_chat.dart';
import 'package:kotobekia/modules/message_screen/component/text_in_message.dart';
import 'package:kotobekia/shared/component/divider_line.dart';
import 'package:kotobekia/shared/component/no_internet.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:kotobekia/shared/styles/colors.dart';
import 'package:solar_icons/solar_icons.dart';
import 'component/user_row_in_message.dart';

class MessageScreen extends StatelessWidget with WidgetsBindingObserver {
  final String name;
  final bool male;
  final String convId;
  final String reciveId;
  final bool online;
  // final String price;
  // final String titlePost;
  // final String categoryPost;
  // final String image;

  const MessageScreen({
    super.key,
    required this.name,
    //required this.price,
    this.online = false,
    required this.reciveId,
    //required this.categoryPost,
    //required this.titlePost,
    required this.convId,
    // required this.image,
    required this.male,
  });

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(milliseconds: 100), () {
      ChatCubit.get(context).controller.animateTo(
        ChatCubit.get(context).controller.position.minScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });
    TextTheme font = Theme.of(context).textTheme;
    final locale = AppLocalizations.of(context);
    ChatCubit.get(context).id = reciveId;
    return WillPopScope(
      onWillPop: () async{
        Navigator.pop(context);
        CacheHelper.removeData(key: AppConstant.convId);
        ChatCubit.get(context).getUsersConversation(token:CacheHelper.getData(key: AppConstant.token));
        ChatCubit.get(context).messages.clear();
        return true;
      },
      child: BlocBuilder<InternetCubit, InternetStates>(
        builder: (context, internetState) {
          return BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              var cubit = context.read<ChatCubit>();
              return internetState is InternetNotConnected||!InternetCubit.get(context).isDeviceConnected?
              const Scaffold(body: BuildNoInternet())
                  :Scaffold(
                body: Column(
                        children: [
                          Material(
                            elevation: 2,
                            shadowColor: Colors.black.withOpacity(0.25),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 15.w, right: 15.w, top: 35.h),
                              color: Theme.of(context).cardColor,
                              //height:100.h,
                              width: double.infinity,
                              child: Column(
                                children: [
                                  SizedBox(height: 4.h,),
                                  BuildUserRowInMessage(
                                    online: online,
                                    recieverId: reciveId,
                                    convId: convId,
                                    chatCubit: cubit,
                                    name: name,
                                    font: font,
                                    male: male,
                                  ),
                                  SizedBox(
                                    height: 9.h,
                                  ),
                                  // const BuildDividerLine(
                                  //   thickness: 1,
                                  // ),
                                  //   BuildItemForUserInChat(
                                  //   font: font,
                                  //   image:
                                  //       AppConstant.imageUrl+image,
                                  //   price: price ,
                                  //   title: titlePost,
                                  //   category: categoryPost,
                                  // ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Expanded(
                            child: ListView.separated(
                                    physics: const ScrollPhysics(),
                                    controller: cubit.controller,
                                    shrinkWrap: true,
                                    reverse: true,
                                    itemBuilder: (context, index) {
                                      final reversedIndex =
                                          cubit.messages.length - 1 - index;

                                      return BuildTextMessage(
                                        date: cubit.messages[reversedIndex][2],
                                        font: font,
                                        text: cubit.messages[reversedIndex].first,
                                        sender: cubit.messages[reversedIndex]
                                                    [1] ==
                                                CacheHelper.getData(
                                                    key: AppConstant.userId)
                                            ? true
                                            : false,
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                      height: 15.h,
                                    ),
                                    itemCount: cubit.messages.length,
                                  )

                          ),
                          Material(
                            elevation: 15,
                            child: Container(
                              constraints: BoxConstraints(
                                maxHeight: 170
                                    .h, // Set a specific maximum height for the container
                              ),
                              width: double.infinity,
                              padding: EdgeInsets.all(12.w),
                              color: Theme.of(context).cardColor,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      style: font.titleMedium,
                                      controller: cubit.messageController,
                                      maxLines: null,
                                      onChanged: (value) {
                                        cubit.changeMessageStatus(value);
                                      },
                                      // Allow the TextFormField to have multiple lines
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 5.w,
                                          horizontal: 10.w,
                                        ),
                                        fillColor: Theme.of(context).focusColor,
                                        filled: true,
                                        hintText: locale.message_placeholder,
                                        hintStyle: font.displayMedium!
                                            .copyWith(fontSize: 12.sp,
                                        ),
                                        // suffixIcon: Padding(
                                        //   padding: EdgeInsets.only(
                                        //       left: CacheHelper.getData(
                                        //           key: AppConstant.languageKey) ==
                                        //           'ar'
                                        //           ? 15.w
                                        //           : 0,
                                        //       right: CacheHelper.getData(
                                        //           key: AppConstant.languageKey) ==
                                        //           'en'
                                        //           ? 15.w
                                        //           : 0),
                                        //   child: Icon(
                                        //     SolarIconsOutline.gallery,
                                        //     color: ColorConstant.primaryColor,
                                        //     size: 24.w,
                                        //   ),
                                        // ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(20.r),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 18.w),
                                  Transform.scale(
                                    scaleX: CacheHelper.getData(
                                                key: AppConstant.languageKey) ==
                                            'ar'
                                        ? -1
                                        : 1,
                                    child: InkWell(
                                      onTap: () {
                                        if(cubit.messageController.text.trim().isNotEmpty){
                                          cubit.sendMessage(
                                            conversationId: convId,
                                            message: cubit.messageController.text,
                                            token: CacheHelper.getData(
                                                key: AppConstant.token),
                                          );
                                          Timer(const Duration(milliseconds: 100),
                                                  () {
                                                cubit.controller.animateTo(
                                                  cubit.controller.position
                                                      .minScrollExtent,
                                                  curve: Curves.easeOut,
                                                  duration:
                                                  const Duration(milliseconds: 300),
                                                );
                                              });
                                          cubit.messageController.clear();
                                        }

                                      },
                                      child: Icon(
                                        cubit.messageController.text.trim().isEmpty?
                                        SolarIconsOutline.plain2
                                        :SolarIconsBold.plain2,
                                        size: 26.w,
                                        color: ColorConstant.primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )

              );
            },
          );
        },
      ),
    );
  }
}
