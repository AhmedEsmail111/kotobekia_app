import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/notification/notification_cubit.dart';
import 'package:kotobekia/shared/component/back_icon.dart';
import 'package:kotobekia/shared/component/handle_time.dart';
import 'package:kotobekia/shared/styles/colors.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen(
      {super.key, required this.numberOfNotitficationUnread});

  final int numberOfNotitficationUnread;

  @override
  Widget build(BuildContext context) {
    var font = Theme.of(context).textTheme;
    final locale = AppLocalizations.of(context);
    final notificationTitle = {
     "post.title":locale.postTitle,
      "post_under_review":locale.postUnderReview,
      "report_under_review":locale.reportUnderReview,
      "post-update":locale.postUpdate,
      "pending":locale.pending,
      "feedback_post_under_review":locale.postFeedBack,
    };
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {

        var cubit = context.read<NotificationCubit>();

        return Scaffold(
            appBar: AppBar(
                leading: BuildBackIcon(
                    backX: true,
                    onTap: () {
                      Navigator.pop(context);
                    }),
                title: Text(
                  locale.notification,
                  style: Theme.of(context).textTheme.bodyLarge,
                )),
            body: cubit.notificationModel == null
                ? const Center(
                    child: CircularProgressIndicator(
                    color: ColorConstant.primaryColor,
                  ))
                : cubit.notificationModel!.result!.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.all(16.h),
                        child: ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {

                              DateTime dateTime = DateTime.parse(cubit
                                  .notificationModel!
                                  .result![index]
                                  .createdAt!);
                              final String time = getTimeDifference(dateTime, locale);
                              return
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 48.w,
                                    height: 48.w,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(18.r),
                                        border: Border.all(
                                            color: cubit
                                                        .notificationModel!
                                                        .result![index]
                                                        .status ==
                                                    "pending"
                                                ? Colors.orange
                                                : cubit
                                                            .notificationModel!
                                                            .result![index]
                                                            .status ==
                                                        "success"
                                                    ? Colors.green
                                                    : cubit
                                                                .notificationModel!
                                                                .result![index]
                                                                .status ==
                                                            'rejected'
                                                        ? Colors.red
                                                        : Colors.blue,
                                            width: 2.5)),
                                    child: Icon(
                                        cubit.notificationModel!.result![index]
                                                    .notificationType ==
                                                "report-update"
                                            ? SolarIconsOutline.shieldWarning
                                            : cubit
                                                        .notificationModel!
                                                        .result![index]
                                                        .notificationType ==
                                                    "post-update"
                                                ? SolarIconsOutline
                                                    .hashtagSquare
                                                : SolarIconsOutline.infoCircle,
                                        size: 25.w,
                                        color: cubit.notificationModel!
                                                    .result![index].status ==
                                                "pending"
                                            ? Colors.orange
                                            : cubit
                                                        .notificationModel!
                                                        .result![index]
                                                        .status ==
                                                    "success"
                                                ? Colors.green
                                                : cubit
                                                            .notificationModel!
                                                            .result![index]
                                                            .status ==
                                                        'rejected'
                                                    ? Colors.red
                                                    : Colors.blue),
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.contain,
                                            child: Text(
                                                  notificationTitle[cubit
                                                  .notificationModel!
                                                  .result![index]
                                                  .body!].toString(),
                                              style: font.bodyLarge!
                                                  .copyWith(fontSize:
                                              13.sp,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2.h,
                                      ),
                                      SizedBox(
                                        width: 165.w,
                                        child: Text(
                                          cubit.notificationModel!
                                              .result![index].title!,
                                          maxLines: 1000,
                                          style: font.bodyMedium!.copyWith(
                                              fontSize: 13.sp,
                                              color:
                                                  ColorConstant.extraGreyColor),
                                        ),
                                      )
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    children: [
                                      Text(
                                        time,
                                        style: font.bodyMedium!.copyWith(
                                            fontSize: 12.sp,
                                            color: Colors.grey),
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      if (index < numberOfNotitficationUnread)
                                        CircleAvatar(
                                          radius: 4.r,
                                          backgroundColor:
                                              ColorConstant.dangerColor,
                                        ),
                                    ],
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: cubit.notificationModel!.result!.length),
                      )
                    : Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 40.r,
                            color: ColorConstant.dangerColor,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            "NO Notification",
                            style: font.bodyLarge,
                          ),
                        ],
                      )));
      },
    );
  }
}
