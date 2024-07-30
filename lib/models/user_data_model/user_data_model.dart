class UserDataModel {
  String? massage;
  UserData? user;
  UserDataModel.fromJson(Map<String, dynamic> json) {
    massage = json['massage'];
    user =
    json['result'] != null ?  UserData.fromJson(json['result']) : null;
  }

}

class UserData {
  String? sId;
  String? fullName;
  String? email;
  String? password;
  String? phoneNumber;
  String? birthDate;
  String? role;
  String? gender;
  bool? termsAndConditions;
  int? postCount;
  String? provider;
  String? oTP;
  bool? isActive;
  bool? isConfirmed;
  bool? isBlocked;
  String? lastVisited;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? isVerified;
  List<String>? yourAds;
  List<String>? notifications;
  int? chatCount;
  List<String>? badges;


  UserData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    email = json['email'];
    password = json['password'];
    phoneNumber = json['phoneNumber'];
    birthDate = json['birthDate'];
    role = json['role'];
    gender = json['gender'];
    termsAndConditions = json['termsAndConditions'];
    postCount = json['postCount'];
    provider = json['provider'];
    oTP = json['OTP'];
    isActive = json['isActive'];
    isConfirmed = json['isConfirmed'];
    isBlocked = json['isBlocked'];
    lastVisited = json['lastVisited'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    isVerified = json['isVerified'];
    yourAds = json['yourAds'] != null ? List<String>.from(json['yourAds']) : [];
    notifications = json['notifications'] != null ? List<String>.from(json['notifications']) : [];
    chatCount = json['chatCount'];
    badges = json['badges'] != null ? List<String>.from(json['badges']) : [];
  }

}

