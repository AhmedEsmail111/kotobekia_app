import 'package:kotobekia/models/post_model/post_model.dart';

class SpecificCategoryModel {
  final String message;
  final int totalPages;
  final int page;
  final int totalDocuments;
  final int remainingPages;
  final int? nextPage;
  final List<Post> posts;

  SpecificCategoryModel({
    required this.message,
    required this.totalPages,
    required this.page,
    required this.totalDocuments,
    required this.remainingPages,
    required this.nextPage,
    required this.posts,
  });

  factory SpecificCategoryModel.fromJson(Map<String, dynamic> json) =>
      SpecificCategoryModel(
        message: json["message"],
        totalPages: json["totalPages"],
        page: json["page"],
        totalDocuments: json["totalDocuments"],
        remainingPages: json["remainingPages"],
        nextPage: json["nextPage"],
        posts:
            List<Post>.from(json["result"].map((post) => Post.fromJson(post))),
      );
}
class CreatedBy {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String gender;
  final bool isVerified;
  final bool isBlocked;

  CreatedBy({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.gender,
    required this.isVerified,
    required this.isBlocked,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
    id: json["_id"],
    fullName: json["fullName"],
    email: json["email"],
    gender: json["gender"],
    phone: json["phoneNumber"],
    isVerified: json["isVerified"],
    isBlocked: json["isBlocked"],
  );
}

