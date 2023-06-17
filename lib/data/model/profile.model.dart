import 'package:gadeer/data/model/category.model.dart';
import 'package:gadeer/data/model/city.model.dart';
import 'package:gadeer/data/model/education.model.dart';
import 'package:gadeer/data/model/section.model.dart';
import 'package:gadeer/data/model/work_experience.model.dart';
import 'package:gadeer/modules/register/bloc/register.event.dart';

class ProfileModel {
  int? id;
  String? name;
  String? gender;
  String? jobTitle;
  String? membershipType;
  String? photo;
  CityModel? area;
  num? rate;
  String? sectionText;
  CityModel? city;
  int? price;
  String? licensefile;
  List<WorkExperienceModel>? workExperiences;
  List<EducationModel>? educations;
  List<CategoryModel>? categories;
  List<SectionModel>? sections;
  int? meetingSeconds;
  int? consultingSeconds;
  List<ProfileFileModel>? files;
  dynamic link;

  bool get isFilesComplete {
    bool toReturn = true;
    if (membershipType == AccountType.consultant.toShortString()) {
      files?.forEach((element) {
        if (element.path == null && element.key != "other") {
          toReturn = false;
        }
      });
    } else {
      toReturn = false;
    }
    return toReturn;
  }
  String get workHours {
    return Duration(seconds: (consultingSeconds ?? 0) + (meetingSeconds ?? 0))
        .inHours
        .toString();
  }

  ProfileModel({
    this.id,
    this.name,
    this.gender,
    this.jobTitle,
    this.membershipType,
    this.photo,
    this.meetingSeconds,
    this.consultingSeconds,
    this.rate,
    this.area,
    this.categories,
    this.city,
    this.sections,
    this.workExperiences,
    this.educations,
    this.licensefile,
    this.link
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    gender = json['gender'];
    link = json['link'];
    jobTitle = json['job_title'];
    price=json['price'];
    sectionText = json["section_text"];
    meetingSeconds = json["meeting_seconds"] ?? 0;
    consultingSeconds = json["consulting_seconds"] ?? 0;
    membershipType = json['membership_type'];
    photo = json['photo'];
    rate = json["rate"];
    licensefile = json["license_file"];
    if (json['area'] != null) {
      area = CityModel.fromJson(json['area']);
    }
    if (json['city'] != null) {
      city = CityModel.fromJson(json['city']);
    }

    if (json['sections'] != null) {
      sections = <SectionModel>[];
      json['sections'].forEach((item) {
        sections!.add(SectionModel.fromJson(item));
      });
    }

    if (json['files'] != null) {
      files = <ProfileFileModel>[];
      json['files'].forEach((item) {
        files!.add(ProfileFileModel.fromJson(item));
      });
    }

    if (json['work_experiences'] != null) {
      workExperiences = <WorkExperienceModel>[];
      json['work_experiences'].forEach((item) {
        workExperiences!.add(WorkExperienceModel.fromJson(item));
      });
    }
    if (json['categories'] != null) {
      categories = <CategoryModel>[];
      json['categories'].forEach((item) {
        categories!.add(CategoryModel.fromJson(item));
      });
    }

    if (json['educations'] != null) {
      educations = <EducationModel>[];
      json['educations'].forEach((item) {
        educations!.add(EducationModel.fromJson(item));
      });
    }
  }
}
class ProfileFileModel {
  String? key;
  String? name;
  String? path;

  ProfileFileModel({this.key, this.name, this.path});

  ProfileFileModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['name'];
    path = json['path'];
  }
}