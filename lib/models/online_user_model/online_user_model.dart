
class OnlineUserModel {
  String? userId;
  String? socketId;


  OnlineUserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    socketId = json['socketId'];
  }

}