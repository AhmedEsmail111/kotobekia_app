import 'package:kotobekia/models/conversation_model/conversation_model.dart';

class ConversationTwoUserModel {
  String? sId;
  String? name;
  String? receiverId;
  String? gender;
  bool? isGroup;
  List<UnreadMessages>? unreadMessages;
  bool? reported;
  List<User>? users;
  String? createdAt;
  String? updatedAt;
  int? iV;



  ConversationTwoUserModel.fromJson(Map<String, dynamic> json) {
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
      users = <User>[];
      json['users'].forEach((v) {
        users!.add( User.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
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

class User {
  String? sId;
  String? fullName;
  String? gender;


  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    gender = json['gender'];
  }
}

class ConversationPost {
  String? sId;
  String? title;
  String? description;
  List<String>? images;
  dynamic price;

  ConversationPost.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    images = json['images'] != null ? List<String>.from(json['images']) : null;
    price = json['price'].toString();
  }


}