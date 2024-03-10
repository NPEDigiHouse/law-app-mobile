// Package imports:
import 'package:equatable/equatable.dart';

class DashboardDataModel extends Equatable {
  final int? totalDiscussions;
  final int? totalCourses;
  final int? totalBooksRead;
  final int? totalBooksSaved;
  final int? totalBooks;
  final int? totalWords;
  final int? totalUsers;

  const DashboardDataModel({
    this.totalDiscussions,
    this.totalCourses,
    this.totalBooksRead,
    this.totalBooksSaved,
    this.totalBooks,
    this.totalWords,
    this.totalUsers,
  });

  DashboardDataModel copyWith({
    int? totalDiscussions,
    int? totalCourses,
    int? totalBooksRead,
    int? totalBooksSaved,
    int? totalBooks,
    int? totalWords,
    int? totalUsers,
  }) {
    return DashboardDataModel(
      totalDiscussions: totalDiscussions ?? this.totalDiscussions,
      totalCourses: totalCourses ?? this.totalCourses,
      totalBooksRead: totalBooksRead ?? this.totalBooksRead,
      totalBooksSaved: totalBooksSaved ?? this.totalBooksSaved,
      totalBooks: totalBooks ?? this.totalBooks,
      totalWords: totalWords ?? this.totalWords,
      totalUsers: totalUsers ?? this.totalUsers,
    );
  }

  factory DashboardDataModel.fromMap(Map<String, dynamic> map) {
    return DashboardDataModel(
      totalDiscussions: map['totalDiscussions'] as int?,
      totalCourses: map['totalCourses'] as int?,
      totalBooksRead: map['totalBooksRead'] as int?,
      totalBooksSaved: map['totalBooksSaved'] as int?,
      totalBooks: map['totalBooks'] as int?,
      totalWords: map['totalWords'] as int?,
      totalUsers: map['totalUsers'] as int?,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      totalDiscussions,
      totalCourses,
      totalBooksRead,
      totalBooksSaved,
      totalBooks,
      totalWords,
      totalUsers,
    ];
  }
}
