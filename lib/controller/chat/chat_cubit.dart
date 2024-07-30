import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kotobekia/models/conversation_model/conversation_model.dart';
import 'package:kotobekia/models/conversation_two_user_model/conversation_two_user_model.dart';
import 'package:kotobekia/models/identity_user_model/identity_user_model.dart';
import 'package:kotobekia/models/message_model/message_model.dart';
import 'package:kotobekia/models/online_user_model/online_user_model.dart';
import 'package:kotobekia/shared/constants/api/api_constant.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:kotobekia/shared/network/remote/remote.dart';
import 'package:kotobekia/shared/network/remote/socket.io.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  static ChatCubit get(context) => BlocProvider.of(context);

  ConversationModel? conversationModel;
  List<Users> otherUsers = [];
  List<String> conversationsId = [];
  IdentityUserModel? identityUserModel;

  void getUsersConversation({
    required String? token,
  }) async {
    emit(LoadingUsersConversationState());
    otherUsers.clear();
    conversationsId.clear();

    try {
      final Response response = await DioHelper.getData(
        lang: AppConstant.lang,
          url: ApiConstant.getConversation, token: token);
      Map<String, dynamic> responseData = response.data;
      otherUsers.clear();
      conversationsId.clear();
      conversationPosts.clear();
      conversationModel = ConversationModel.fromJson(responseData);
      otherUsers.addAll(conversationModel!.conversations!.expand((e) {
        return [
          if (e.users![0].sId != CacheHelper.getData(key: AppConstant.userId))
            e.users![0],
          if (e.users![1].sId != CacheHelper.getData(key: AppConstant.userId))
            e.users![1],
        ];
      }));

      otherUsers.toSet().toList();

      for (var e in conversationModel!.conversations!) {
        conversationsId.add(e.sId!);
      }

      emit(SuccessUsersConversationState(conversationModel!));
    } catch (error) {
      if (error is DioError) {
        Map<String, dynamic> responseData = error.response!.data;
        conversationModel = ConversationModel.fromJson(responseData);
        print(error.response!.data);
        emit(SuccessUsersConversationState(conversationModel!));
      } else {
        emit(FailedUsersConversationState(error.toString()));
      }
    }
  }

  ConversationTwoUserModel? conversationTwoUserModel;

  void openUserConversation(
      {required String token, required String receiverId}) async {
    emit(LoadingOpenUserConversationState());
    try {
      final Response response = await DioHelper.postData(
        lang: AppConstant.lang,
          url: ApiConstant.openConversation,
          token: token,
          data: {'receiver_id': receiverId});
      Map<String, dynamic> responseData = response.data;
      conversationTwoUserModel =
          ConversationTwoUserModel.fromJson(responseData);
      emit(SuccessOpenUserConversationState(conversationTwoUserModel!));
    } catch (error) {
      emit(FailedOpenUserConversationState(error.toString()));
    }
  }



  List<List<String>> messages = [];
  var socket = SocketIO.socket;
  final ScrollController controller = ScrollController();
  bool isEmptyMessage = false;

  void getMessage({required String token, required String id}) {
    messages.clear();
    DioHelper.getData(
      lang: AppConstant.lang,
      url: ApiConstant.getMessage(id),
      token: token,
    ).then((value) {
      messages.clear();
      List<dynamic> responseData = value.data;
      for (var element in responseData) {
        messageModel = MessageModel.fromJson(element);
        messages.add([
          messageModel!.message!,
          messageModel!.sender!.sId!,
          messageModel!.createdAt!
        ]);
      }
      emit(SuccessGetMessageState());
      isEmptyMessage = true;
    }).catchError((error) {
      emit(FailedGetMessageState(error));
    });
  }
  void joinSocket(String userId){
    socket?.emit("join", userId);
  }

  String id='';
  void recieveMessage() {
    socket!.on('receive-message', (data) {
      messageModel = MessageModel.fromJson(data);
      messages.add([
        messageModel!.message!,
        messageModel!.sender!.sId!,
        messageModel!.createdAt!
      ]);

      emit(SuccessReciveMessageSocketState());
        getUsersConversation(token: CacheHelper.getData(key: AppConstant.token));

    });
  }

  MessageModel? messageModel;

  void sendMessage(
      {required String conversationId,
      required String message,
      required String token}) {
    emit(LoadingSendMessageState());
    DioHelper.postData(
      lang: AppConstant.lang,
        url: ApiConstant.sendMessage,
        token: token,
        data: {"convo_id": conversationId, "message": message}).then((value) {
      Map<String, dynamic> responseData = value.data;
      messageModel = MessageModel.fromJson(responseData);
      messages
          .add([message, messageModel!.sender!.sId!, messageModel!.createdAt!]);
      _sendMsg(responseData);
      emit(SuccessSendMessageState());
    }).catchError((error) {
      emit(FailedSendMessageState(error));
    });
  }

  void _sendMsg(dynamic messageModel) {
    socket!.emit('send-message', messageModel);
  }
  Set<String>onlineUserId={};
  void getOnlineUser(){
    socket!.on("get-online-users", (data) {
      onlineUserId.clear();
      for(Map<String,dynamic> user in data){
        OnlineUserModel onlineUserModel=OnlineUserModel.fromJson(user);
        onlineUserId.add(onlineUserModel.userId!);
      }
      emit(SuccessGetOnlineUserState());
    });
  }


  var messageController = TextEditingController();

  void changeMessageStatus(String value) {
    messageController.text = value;
    emit(SuccessChangeMessageStatusState());

  }
}
