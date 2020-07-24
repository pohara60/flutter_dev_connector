// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
    id: json['_id'] as String,
    text: json['text'] as String,
    userId: json['user'] as String,
    name: json['name'] as String,
    avatar: json['avatar'] as String,
  )
    ..likes = (json['likes'] as List)
        ?.map(
            (e) => e == null ? null : Like.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..comments = (json['comments'] as List)
        ?.map((e) =>
            e == null ? null : Comment.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      '_id': instance.id,
      'text': instance.text,
      'user': instance.userId,
      'name': instance.name,
      'avatar': instance.avatar,
      'likes': instance.likes,
      'comments': instance.comments,
    };

Like _$LikeFromJson(Map<String, dynamic> json) {
  return Like(
    id: json['_id'] as String,
    userId: json['userId'] as String,
  );
}

Map<String, dynamic> _$LikeToJson(Like instance) => <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
    };

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment(
    id: json['_id'] as String,
    text: json['text'] as String,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    userId: json['user'] as String,
    name: json['name'] as String,
    avatar: json['avatar'] as String,
  );
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      '_id': instance.id,
      'text': instance.text,
      'date': instance.date?.toIso8601String(),
      'user': instance.userId,
      'name': instance.name,
      'avatar': instance.avatar,
    };
