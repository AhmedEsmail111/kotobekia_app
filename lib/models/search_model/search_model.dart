class SearchModel {
  String? message;
  List<ResultPosts>? result;

  SearchModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['result'] != null) {
      result = <ResultPosts>[];
      json['result'].forEach((v) {
        result!.add( ResultPosts.fromJson(v));
      });
    }
  }

}

class ResultPosts {
  String? sId;
  String? title;
  String? description;
  List<String>? images;
  String? postType;
  String? price;
  String? grade;
  String? bookEdition;
  String? educationLevel;
  String? postStatus;
  int? views;
  String? feedback;
  int? numberOfBooks;
  String? educationTerm;
  String? educationType;
  String? location;
  List<String>? userFavorite;
  bool? reported;
  String? city;
  CreatedBy? createdBy;
  String? identificationNumber;
  String? createdAt;
  String? updatedAt;
  int? postId;

  ResultPosts.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    images = json['images'].cast<String>();
    postType = json['postType'];
    price = json['price'];
    grade = json['grade'];
    bookEdition = json['bookEdition'];
    educationLevel = json['educationLevel'];
    postStatus = json['postStatus'];
    views = json['views'];
    feedback = json['feedback'];
    numberOfBooks = json['numberOfBooks'];
    educationTerm = json['educationTerm'];
    educationType = json['educationType'];
    location = json['location'];
    userFavorite = json['userFavorite'].cast<String>();
    reported = json['reported'];
    city = json['city'];
    createdBy = json['createdBy'] != null
        ?  CreatedBy.fromJson(json['createdBy'])
        : null;
    identificationNumber = json['identificationNumber'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    postId = json['postId'];
  }

}

class CreatedBy {
  String? sId;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? gender;
  bool? isBlocked;
  bool? isVerified;

  CreatedBy.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    gender = json['gender'];
    isBlocked = json['isBlocked'];
    isVerified = json['isVerified'];
  }

}