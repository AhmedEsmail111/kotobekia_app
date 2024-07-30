class NotificationModel {
  String? message;
  List<Result>? result;


  NotificationModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add( Result.fromJson(v));
      });
    }
  }

}

class Result {
  String? sId;
  String? title;
  String? body;
  String? status;
  String? notificationType;
  String? referenceId;
  String? image;
  bool? isRead;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Result.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    body = json['body'];
    status = json['status'];
    notificationType = json['notification_type'];
    referenceId = json['reference_id'];
    image = json['image'];
    isRead = json['isRead'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }


}