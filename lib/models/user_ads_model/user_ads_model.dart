import 'package:kotobekia/models/post_model/post_model.dart';

class UserAdsModel {
  final String message;
  final List<Post> posts;

  UserAdsModel({
    required this.message,
    required this.posts,
  });

  factory UserAdsModel.fromJson(Map<String, dynamic> json) => UserAdsModel(
        message: json["message"],
        posts:
            List<Post>.from(json["result"].map((post) => Post.fromJson(post))),
      );
}
