import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kotobekia/models/notification_model/notification_model.dart';
import 'package:kotobekia/shared/constants/api/api_constant.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:kotobekia/shared/network/remote/remote.dart';
import 'package:kotobekia/shared/network/remote/socket.io.dart';
import 'package:meta/meta.dart';
part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());
  static NotificationCubit get(context) => BlocProvider.of(context);

  var socket=SocketIO.socket;
  NotificationModel ?notificationModel;
  int length=0;
  void getNotifications(){
    length=0;
    emit(LoadingGetNotificationState ());
    DioHelper.getData(
        lang: AppConstant.lang,
        url: ApiConstant.notificationsUrl,
    token: CacheHelper.getData(key: AppConstant.token)
    ).then((value) {
      length=0;
      notificationModel=NotificationModel.fromJson(value.data);
      for (var element in notificationModel!.result!) {
        if(!element.isRead!){
          length++;
        }
      }
      emit(SuccessGetNotificationState());
    }).catchError((error){
      emit(FailureGetNotificationState());
    });
  }
  void readNotifications(){
    emit(LoadingReadNotificationState());
    DioHelper.patchData(
        lang: AppConstant.lang,
        url: ApiConstant.readNotificationsUrl,
    token: CacheHelper.getData(key: AppConstant.token)
    ).
    then((value){
      emit(SuccessReadNotificationState());
      getNotifications();
    }).catchError((error){
      emit(FailureReadNotificationState());
    });
  }
  void changeStateNotify(){
    socket!.on('new-notification', (data) {
      getNotifications();
      emit(ChangeStateNotificationState());
    });
  }
}
