class UserModel {
  String? message;
  List<User>? user;
  String? token;

  UserModel.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? json['msgError'];
    token = json['Token'] ?? json['token'];
    dynamic userJson = json['user'];
    if (userJson is List<dynamic>) {
      user = (json['user'] as List<dynamic>?)
          ?.map((j) => User.fromJson(j))
          .toList();
    } else if (userJson is Map<String, dynamic>) {
      user = [User.fromJson(userJson)];
    }
  }
}

class User {
  String? fullName;
  String? email;
  String? password;
  String? phoneNumber;
  String? birthDate;
  String? role;
  String? gender;

  bool? termsAndConditions;
  // List<int>? yourAds;
  // List<dynamic>? favorite;
  String? provider;
  bool? isActive;
  bool? isConfirmed;
  bool? isBlocked;
  String? lastVisited;
  String? sId;
  int? iV;
  String? createdAt;
  String? updatedAt;

  User.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    email = json['email'];
    password = json['password'];
    phoneNumber = json['phoneNumber'];
    birthDate = json['birthDate'];
    role = json['role'];
    gender = json['gender'];

    termsAndConditions = json['termsAndConditions'];
    // if (json['yourAds'] != null) {
    //   yourAds = <int>[];
    //   json['yourAds'].forEach((v) {
    //     yourAds!.add( Null.fromJson(v));
    //   });
    // }
    // if (json['favorite'] != null) {
    //   favorite = <dynamic>[];
    //   json['favorite'].forEach((v) {
    //     favorite!.add(new Null.fromJson(v));
    //   });
    // }
    provider = json['provider'];
    isActive = json['isActive'];
    isConfirmed = json['isConfirmed'];
    isBlocked = json['isBlocked'];
    lastVisited = json['lastVisited'];
    sId = json['_id'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}
