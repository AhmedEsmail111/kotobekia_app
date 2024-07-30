class IdentityUserModel {
  String? id;
  String? fullName;
  String? email;
  String? role;
  String? gender;
  String? birthDate;

  IdentityUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    email = json['email'];
    role = json['role'];
    gender = json['gender'];
    birthDate = json['birthDate'];
  }
}
