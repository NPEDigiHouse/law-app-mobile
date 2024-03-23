// Package imports:
import 'package:equatable/equatable.dart';

class CourseModel extends Equatable {
  final int? id;
  final String? title;
  final String? description;
  final String? coverImg;
  final int? courseDuration;
  final int? rating;
  final int? enrolledMembers;

  const CourseModel({
    this.id,
    this.title,
    this.description,
    this.coverImg,
    this.courseDuration,
    this.rating,
    this.enrolledMembers,
  });

  CourseModel copyWith({
    int? id,
    String? title,
    String? description,
    String? coverImg,
    int? courseDuration,
    int? rating,
    int? enrolledMembers,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      coverImg: coverImg ?? this.coverImg,
      courseDuration: courseDuration ?? this.courseDuration,
      rating: rating ?? this.rating,
      enrolledMembers: enrolledMembers ?? this.enrolledMembers,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'coverImg': coverImg,
      'courseDuration': courseDuration,
      'rating': rating,
      'enrolledMembers': enrolledMembers,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] as int?,
      title: map['title'] as String?,
      description: map['description'] as String?,
      coverImg: map['coverImg'] as String?,
      courseDuration: map['courseDuration'] as int?,
      rating: map['rating'] as int?,
      enrolledMembers: map['enrolledMembers'] as int?,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        coverImg,
        courseDuration,
        rating,
        enrolledMembers,
      ];
}
