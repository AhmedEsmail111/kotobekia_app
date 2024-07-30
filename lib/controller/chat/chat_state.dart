part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChangeCheckTypeChatState extends ChatState {}


class LoadingUsersConversationState extends ChatState {}

class SuccessUsersConversationState extends ChatState {
  final ConversationModel userModel;

  SuccessUsersConversationState(this.userModel);
}

class FailedUsersConversationState extends ChatState {
  final String error;

  FailedUsersConversationState(this.error);
}



class LoadingOpenUserConversationState extends ChatState {}

class SuccessOpenUserConversationState extends ChatState {
  final ConversationTwoUserModel conversationTwoUserModel;

  SuccessOpenUserConversationState(this.conversationTwoUserModel);
}

class FailedOpenUserConversationState extends ChatState {
  final String error;

  FailedOpenUserConversationState(this.error);
}


class LoadingGetMessageState extends ChatState {}

class SuccessGetMessageState extends ChatState {}

class SuccessConnectSocketState extends ChatState {}

class SuccessReciveMessageSocketState extends ChatState {}

class FailedGetMessageState extends ChatState {
  final String error;

  FailedGetMessageState(this.error);
}

class LoadingSendMessageState extends ChatState {}

class SuccessSendMessageState extends ChatState {}

class FailedSendMessageState extends ChatState {
  final String error;

  FailedSendMessageState(this.error);
}


class SuccessGetOnlineUserState extends ChatState {}

class SuccessChangeMessageStatusState extends ChatState {}



