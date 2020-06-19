import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_dev_connector/models/user.dart';

// flutter pub run build_runner build
part 'profile.g.dart';

@JsonSerializable()
class Profile {
  @JsonKey(name: '_id')
  String id;
  User user;
  String company;
  String website;
  String location;
  String status;
  List<String> skills;
  String bio;
  String githubusername;
  List<Experience> experience;
  List<Education> education;
  Social social;
  DateTime date;

  Profile({
    this.id,
    this.user,
    this.company,
    this.website,
    this.location,
    this.status,
    this.skills,
    this.bio,
    this.githubusername,
    this.experience,
    this.education,
    this.social,
    this.date,
  });
  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

@JsonSerializable()
class Social {
  String youtube;
  String twitter;
  String facebook;
  String linkedin;
  String instagram;

  Social({
    this.youtube,
    this.twitter,
    this.facebook,
    this.linkedin,
    this.instagram,
  });
  factory Social.fromJson(Map<String, dynamic> json) => _$SocialFromJson(json);
  Map<String, dynamic> toJson() => _$SocialToJson(this);
}

@JsonSerializable()
class Experience {
  @JsonKey(name: '_id')
  String id;
  String title;
  String company;
  String location;
  DateTime from;
  DateTime to;
  bool current;
  String description;

  Experience({
    this.id,
    this.title,
    this.company,
    this.location,
    this.from,
    this.to,
    this.current,
    this.description,
  });
  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);
  Map<String, dynamic> toJson() => _$ExperienceToJson(this);
}

@JsonSerializable()
class Education {
  @JsonKey(name: '_id')
  String id;
  String school;
  String degree;
  String fieldofstudy;
  DateTime from;
  DateTime to;
  bool current;
  String description;

  Education({
    this.id,
    this.school,
    this.degree,
    this.fieldofstudy,
    this.from,
    this.to,
    this.current,
    this.description,
  });
  factory Education.fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);
  Map<String, dynamic> toJson() => _$EducationToJson(this);
}

@JsonSerializable()
class Repo {
  @JsonKey(name: '_id')
  final String id;
  @JsonKey(name: 'html_url')
  final String htmlUrl;
  final String name;
  final String description;
  @JsonKey(name: 'stargazers_count')
  final int stargazersCount;
  @JsonKey(name: 'watchers_count')
  final int watchersCount;
  @JsonKey(name: 'forks_count')
  final int forksCount;

  Repo({
    this.id,
    this.htmlUrl,
    this.name,
    this.description,
    this.stargazersCount,
    this.watchersCount,
    this.forksCount,
  });

  factory Repo.fromJson(Map<String, dynamic> json) => _$RepoFromJson(json);
  Map<String, dynamic> toJson() => _$RepoToJson(this);
}
