import 'package:kotobekia/controller/chat/chat_cubit.dart';
import 'package:kotobekia/models/conversation_two_user_model/conversation_two_user_model.dart';
List<ConversationPost> conversationPosts=[];
class ConversationModel {
  List<Conversations>? conversations;

  ConversationModel.fromJson(Map<String, dynamic> json) {
    if (json['conversations'] != null) {
      conversations = <Conversations>[];
      json['conversations'].forEach((v) {
        conversations!.add( Conversations.fromJson(v));
      });
    }
  }

}

class Conversations {
  String? sId;
  String? name;
  String? receiverId;
  String? gender;
  bool? isGroup;
  List<UnreadMessages>? unreadMessages;
  bool? reported;
  List<Users>? users;
  String? createdAt;
  String? updatedAt;
  int? iV;
  LatestMessage? latestMessage;
  ConversationPost? conversationPost;

  Conversations.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    receiverId = json['receiverId'];
    gender = json['gender'];
    isGroup = json['isGroup'];
    if (json['unreadMessages'] != null) {
      unreadMessages = <UnreadMessages>[];
      json['unreadMessages'].forEach((v) {
        unreadMessages!.add( UnreadMessages.fromJson(v));
      });
    }
    reported = json['reported'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add( Users.fromJson(v));
      });
    }

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    if(json['conversation_post'] != null){
      conversationPost=ConversationPost.fromJson(json['conversation_post']);
      conversationPosts.add(conversationPost!);
    }

    iV = json['__v'];
    latestMessage = json['latestMessage'] != null
        ?  LatestMessage.fromJson(json['latestMessage'])
        : null;
  }

}

class UnreadMessages {
  String? user;
  int? count;
  String? sId;


  UnreadMessages.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    count = json['count'];
    sId = json['_id'];
  }
}

class Users {
  String? sId;
  String? fullName;
  String? email;
  String? gender;


  Users.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    email = json['email'];
    gender = json['gender'];
  }

}

class LatestMessage {
  String? sId;
  Sender? sender;
  String? message;
  String? conversation;
  //List<Null>? files;
  String? createdAt;
  String? updatedAt;
  int? iV;


  LatestMessage.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sender =
    json['sender'] != null ?  Sender.fromJson(json['sender']) : null;
    message = json['message']??' ';
    conversation = json['conversation'];
    // if (json['files'] != null) {
    //   files = <Null>[];
    //   json['files'].forEach((v) {
    //     files!.add( Null.fromJson(v));
    //   });
    // }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

}

class Sender {
  String? sId;
  String? fullName;
  String? gender;

  Sender.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    gender = json['gender'];
  }
}


