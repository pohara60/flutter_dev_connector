import 'package:json_annotation/json_annotation.dart';

// flutter pub run build_runner build
part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: '_id')
  String id;
  String name;
  String email;
  String password;
  String avatar;
  DateTime date;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.avatar,
    this.date,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
