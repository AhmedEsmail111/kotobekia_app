class OtpModel {
  String? message;

  OtpModel.fromJson(Map<String,dynamic>json) {
    message = json['message']??json['msgError'];
  }

}