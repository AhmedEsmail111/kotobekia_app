

class MessageModel {
  String? sId;
  Sender? sender;
  String? message;
  Conversation? conversation;
  String? createdAt;
  String? updatedAt;
  int? iV;



  MessageModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sender =
    json['sender'] != null ?  Sender.fromJson(json['sender']) : null;
    message = json['message'];
    conversation = json['conversation'] != null
        ?  Conversation.fromJson(json['conversation'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

}

class Sender {
  String? sId;
  String? fullName;
  String? email;

  Sender.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    email = json['email'];
  }

}

class Conversation {
  String? sId;
  String? name;
  String? receiverId;
  String? gender;
  bool? isGroup;
  List<UnreadMessages>? unreadMessages;
  bool? reported;
  List<String>? users;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? latestMessage;


  Conversation.fromJson(Map<String, dynamic> json) {
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
    users = json['users'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    latestMessage = json['latestMessage'];
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