// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    company: json['company'] as String,
    website: json['website'] as String,
    location: json['location'] as String,
    status: json['status'] as String,
    skills: (json['skills'] as List)?.map((e) => e as String)?.toList(),
    bio: json['bio'] as String,
    githubusername: json['githubusername'] as String,
    experience: (json['experience'] as List)
        ?.map((e) =>
            e == null ? null : Experience.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    education: (json['education'] as List)
        ?.map((e) =>
            e == null ? null : Education.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    social: json['social'] == null
        ? null
        : Social.fromJson(json['social'] as Map<String, dynamic>),
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'user': instance.user,
      'company': instance.company,
      'website': instance.website,
      'location': instance.location,
      'status': instance.status,
      'skills': instance.skills,
      'bio': instance.bio,
      'githubusername': instance.githubusername,
      'experience': instance.experience,
      'education': instance.education,
      'social': instance.social,
      'date': instance.date?.toIso8601String(),
    };

Social _$SocialFromJson(Map<String, dynamic> json) {
  return Social(
    youtube: json['youtube'] as String,
    twitter: json['twitter'] as String,
    facebook: json['facebook'] as String,
    linkedin: json['linkedin'] as String,
    instagram: json['instagram'] as String,
  );
}

Map<String, dynamic> _$SocialToJson(Social instance) => <String, dynamic>{
      'youtube': instance.youtube,
      'twitter': instance.twitter,
      'facebook': instance.facebook,
      'linkedin': instance.linkedin,
      'instagram': instance.instagram,
    };

Experience _$ExperienceFromJson(Map<String, dynamic> json) {
  return Experience(
    title: json['title'] as String,
    company: json['company'] as String,
    location: json['location'] as String,
    from: json['from'] == null ? null : DateTime.parse(json['from'] as String),
    to: json['to'] == null ? null : DateTime.parse(json['to'] as String),
    current: json['current'] as bool,
    description: json['description'] as String,
  );
}

Map<String, dynamic> _$ExperienceToJson(Experience instance) =>
    <String, dynamic>{
      'title': instance.title,
      'company': instance.company,
      'location': instance.location,
      'from': instance.from?.toIso8601String(),
      'to': instance.to?.toIso8601String(),
      'current': instance.current,
      'description': instance.description,
    };

Education _$EducationFromJson(Map<String, dynamic> json) {
  return Education(
    school: json['school'] as String,
    degree: json['degree'] as String,
    fieldofstudy: json['fieldofstudy'] as String,
    from: json['from'] == null ? null : DateTime.parse(json['from'] as String),
    to: json['to'] == null ? null : DateTime.parse(json['to'] as String),
    current: json['current'] as bool,
    description: json['description'] as String,
  );
}

Map<String, dynamic> _$EducationToJson(Education instance) => <String, dynamic>{
      'school': instance.school,
      'degree': instance.degree,
      'fieldofstudy': instance.fieldofstudy,
      'from': instance.from?.toIso8601String(),
      'to': instance.to?.toIso8601String(),
      'current': instance.current,
      'description': instance.description,
    };
