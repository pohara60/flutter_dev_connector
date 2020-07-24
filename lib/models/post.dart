import 'package:json_annotation/json_annotation.dart';

// flutter pub run build_runner build
part 'post.g.dart';

@JsonSerializable()
class Post {
  @JsonKey(name: '_id')
  String id;
  String text;
  @JsonKey(name: 'user')
  String userId;
  String name;
  String avatar;
  List<Like> likes;
  List<Comment> comments;

  Post({
    this.id,
    this.text,
    this.userId,
    this.name,
    this.avatar,
  });
  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}

@JsonSerializable()
class Like {
  @JsonKey(name: '_id')
  String id;
  String userId;

  Like({
    this.id,
    this.userId,
  });
  factory Like.fromJson(Map<String, dynamic> json) => _$LikeFromJson(json);
  Map<String, dynamic> toJson() => _$LikeToJson(this);
}

@JsonSerializable()
class Comment {
  @JsonKey(name: '_id')
  String id;
  String text;
  DateTime date;
  @JsonKey(name: 'user')
  String userId;
  String name;
  String avatar;

  Comment({
    this.id,
    this.text,
    this.date,
    this.userId,
    this.name,
    this.avatar,
  });
  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
