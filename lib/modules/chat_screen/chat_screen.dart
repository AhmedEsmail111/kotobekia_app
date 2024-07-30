import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/chat/chat_cubit.dart';
import 'package:kotobekia/controller/home/home_cubit.dart';
import 'package:kotobekia/controller/internet/internet-states.dart';
import 'package:kotobekia/controller/internet/internet_cubit.dart';
import 'package:kotobekia/modules/message_screen/message_screen.dart';
import 'package:kotobekia/shared/component/divider_line.dart';
import 'package:kotobekia/modules/chat_screen/component/security_guidelines.dart';
import 'package:kotobekia/modules/chat_screen/component/users_chat.dart';
import 'package:kotobekia/shared/component/no_internet.dart';
import 'package:kotobekia/shared/component/shimmer_loading.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/constants/images/images_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:solar_icons/solar_icons.dart';

import '../../models/conversation_model/conversation_model.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    TextTheme font = Theme.of(context).textTheme;
    double w = MediaQuery.sizeOf(context).width;
    double h = MediaQuery.sizeOf(context).height;
    var searchController = TextEditingController();
    var cubit = context.read<ChatCubit>();
    if (cubit.conversationModel == null) {
      cubit.getUsersConversation(
          token: CacheHelper.getData(key: AppConstant.token));
    }
    if (cubit.socket!.disconnected) {
      cubit.socket!.connect();
    }
    return BlocBuilder<InternetCubit, InternetStates>(
      builder: (context, internetState) {
        return BlocConsumer<ChatCubit, ChatState>(
          builder: (context, state) {
            return WillPopScope(
              onWillPop: () async {
                Navigator.pushReplacementNamed(context, 'homeLayout');
                HomeCubit.get(context).changeBottomNavBarIndex(0, context);
                return true;
              },
              child:internetState is InternetNotConnected||!InternetCubit.get(context).isDeviceConnected?
              const BuildNoInternet()
              :Scaffold(
                body: cubit.conversationModel != null
                    ? SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: w / 26, right: w / 26, top: h / 14),
                          child: Column(
                            children: [
                              Text(
                                locale.messages,
                                style: font.titleMedium!
                                    .copyWith(fontSize: w / 21),
                              ),
                              SizedBox(
                                height: h / 21,
                              ),
                              // BuildDefaultTextField(
                              //     withEyeVisible: false,
                              //     prefixIcons: const Icon(Icons.search),
                              //     backGroundColor: ColorConstant.foregroundColor,
                              //     inputType: TextInputType.text,
                              //     withText: false,
                              //     hintText: locale.search_by_name,
                              //     context: context,
                              //     controller: searchController,
                              //     width: double.infinity,
                              //     height: h / 16.8,
                              //     maxLenght: 225,
                              //     isObscured: false),
                              SizedBox(
                                height: h / 58,
                              ),
                              BuildSecurityGuideLines(h: h, w: w, font: font),
                              SizedBox(
                                height: h / 40,
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(18.h),
                                decoration: BoxDecoration(
                                  color:Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(w / 30),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          locale.chat,
                                          style: font.titleMedium,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                     Divider(
                                        color: Theme.of(context).dividerColor,
                                        thickness: 1),
                                    cubit.conversationModel!.conversations!
                                            .isEmpty
                                        ? SizedBox(
                                            height: 230.h,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  SolarIconsOutline.chatDots,
                                                  size: 45.w,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                Text(
                                                  locale.noMessages,
                                                  style: font.bodyLarge!
                                                      .copyWith(
                                                          fontSize: 15.sp),
                                                ),
                                                // SizedBox(height: 5.h,),
                                                // Text(locale.markedFavourite,style: font.headlineMedium!
                                                //     .copyWith(color: Colors.grey,fontSize: 17.sp),),
                                              ],
                                            ),
                                          )
                                        : ListView.separated(
                                            padding: EdgeInsets.only(top: 6.h),
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              bool online = false;
                                              for (var element
                                                  in cubit.onlineUserId) {
                                                if (element ==
                                                    cubit.otherUsers[index]
                                                        .sId!) {
                                                  online = true;
                                                  break;
                                                }
                                              }
                                              return InkWell(
                                                onTap: () {
                                                  ChatCubit.get(context).getMessage(
                                                      token:
                                                          CacheHelper.getData(
                                                              key: AppConstant
                                                                  .token),
                                                      id: cubit.conversationsId[
                                                          index]);
                                                  cubit.openUserConversation(
                                                      token:
                                                          CacheHelper.getData(
                                                              key: AppConstant
                                                                  .token),
                                                      receiverId: cubit
                                                          .otherUsers[index]
                                                          .sId!);
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                    builder: (context) {
                                                      return MessageScreen(
                                                        // image: conversationPosts[index].images!.first,
                                                        // price: conversationPosts[index].price!,
                                                        //   titlePost: conversationPosts[index].title!,
                                                        //   categoryPost: conversationPosts[index].description!,
                                                          online: online,
                                                          reciveId: cubit
                                                              .otherUsers[index]
                                                              .sId!,
                                                          convId: cubit
                                                                  .conversationsId[
                                                              index],
                                                          name: cubit
                                                              .otherUsers[index]
                                                              .fullName!,
                                                          male: cubit
                                                                      .otherUsers[
                                                                          index]
                                                                      .gender ==
                                                                  'male'
                                                              ? true
                                                              : false);
                                                    },
                                                  ));
                                                },
                                                child: BuildUsersChat(
                                                  online: online,
                                                  numberOfUnreadMessage: cubit
                                                          .conversationModel!
                                                          .conversations![index]
                                                          .unreadMessages![0]
                                                          .count ??
                                                      0,
                                                  id: cubit
                                                      .otherUsers[index].sId!,
                                                  font: font,
                                                  image: cubit.otherUsers[index]
                                                              .gender ==
                                                          'male'
                                                      ? ImageConstant
                                                          .userMaleImage
                                                      : ImageConstant
                                                          .userFemaleImage,
                                                  name: cubit.otherUsers[index]
                                                      .fullName!,
                                                  lastMessage: cubit
                                                              .conversationModel!
                                                              .conversations![
                                                                  index]
                                                              .latestMessage ==
                                                          null
                                                      ? ' '
                                                      : cubit
                                                          .conversationModel!
                                                          .conversations![index]
                                                          .latestMessage!
                                                          .message!,
                                                  lastTimeMessage: cubit
                                                              .conversationModel!
                                                              .conversations![
                                                                  index]
                                                              .latestMessage ==
                                                          null
                                                      ? ''
                                                      : cubit
                                                          .conversationModel!
                                                          .conversations![index]
                                                          .latestMessage!
                                                          .createdAt!,
                                                ),
                                              );
                                            },
                                            separatorBuilder:
                                                (context, index) =>
                                                    const BuildDividerLine(),
                                            itemCount: cubit.otherUsers.length),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                      child: Padding(
                          padding: EdgeInsets.all(14.h),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 90.h,
                              ),
                              Skeleton(height: 120.h, width: double.infinity),
                              SizedBox(
                                height: 20.h,
                              ),
                              Skeleton(height: 350.h, width: double.infinity),
                            ],
                          ),
                        ),
                    ),
              ),
            );
          },
          listener: (context, state) {},
        );
      },
    );
  }
}
