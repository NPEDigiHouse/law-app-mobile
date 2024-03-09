//! Course
class Course {
  final String title;
  final String image;
  final int completionTime;
  final int totalStudents;
  final double? rating;
  final String? status;

  const Course({
    required this.title,
    required this.image,
    required this.completionTime,
    required this.totalStudents,
    this.rating,
    this.status,
  });

  Course copyWith({
    String? title,
    String? image,
    int? completionTime,
    int? totalStudents,
    double? rating,
    String? status,
  }) {
    return Course(
      title: title ?? this.title,
      image: image ?? this.image,
      completionTime: completionTime ?? this.completionTime,
      totalStudents: totalStudents ?? this.totalStudents,
      rating: rating ?? this.rating,
      status: status ?? this.status,
    );
  }
}

//! CourseDetail
class CourseDetail extends Course {
  final String description;
  final List<Curriculum> curriculums;
  final double? completePercentage;
  final String? certificateUrl;

  CourseDetail({
    required super.title,
    required super.image,
    required super.completionTime,
    required super.totalStudents,
    super.rating,
    super.status,
    required this.description,
    required this.curriculums,
    this.completePercentage,
    this.certificateUrl,
  });
}

//! Curriculum
class Curriculum {
  final String title;
  final int completionTime;
  final bool? isComplete;
  final List<Lesson> lessons;

  const Curriculum({
    required this.title,
    required this.completionTime,
    this.isComplete,
    required this.lessons,
  });
}

//! Lesson
class Lesson {
  final String title;
  final int completionTime;
  final bool? isComplete;

  const Lesson({
    required this.title,
    required this.completionTime,
    this.isComplete,
  });
}

//! Article
class Article extends Lesson {
  final String content;

  const Article({
    required super.title,
    required super.completionTime,
    super.isComplete,
    required this.content,
  });
}

//! Quiz
class Quiz extends Lesson {
  final String description;
  final Score? currentScore;
  final List<Score>? scoreHistory;
  final List<Item> items;

  const Quiz({
    required super.title,
    required super.completionTime,
    super.isComplete,
    required this.description,
    this.currentScore,
    this.scoreHistory,
    required this.items,
  });
}

//! Score
class Score {
  final int value;
  final String status;
  final DateTime dateObtained;

  Score({
    required this.value,
    required this.status,
    required this.dateObtained,
  });
}

//! Item
class Item {
  final String question;
  final Map<String, String> answers;
  final String rightAnswerOption;

  const Item({
    required this.question,
    required this.answers,
    required this.rightAnswerOption,
  });
}

const dummyCourses = [
  Course(
    title: 'Kupas Tuntas Praktik Hukum Arbitrase',
    image: 'sample-course-image.jpg',
    completionTime: 18,
    totalStudents: 500,
    rating: 4,
  ),
  Course(
    title: 'Seluk Beluk Hukum Pelindungan Data Pribadi',
    image: 'sample-course-image.jpg',
    completionTime: 24,
    totalStudents: 1000,
    rating: 3,
    status: 'active',
  ),
  Course(
    title: 'Tips Menerjemahkan Dokumen Hukum Berbahasa Asing',
    image: 'sample-course-image.jpg',
    completionTime: 15,
    totalStudents: 731,
    rating: 5,
    status: 'active',
  ),
  Course(
    title: 'Memahami Aspek Penting Kebijakan Publik',
    image: 'sample-course-image.jpg',
    completionTime: 20,
    totalStudents: 198,
    status: 'passed',
  ),
  Course(
    title: 'Penyampaian Laporan Kegiatan Penanaman Modal (LKPM)',
    image: 'sample-course-image.jpg',
    completionTime: 10,
    totalStudents: 632,
    rating: 2,
  ),
  Course(
    title: 'Pengantar Dasar-Dasar Kontrak',
    image: 'sample-course-image.jpg',
    completionTime: 8,
    totalStudents: 1200,
  ),
  Course(
    title: 'Mempersiapkan Karier Ideal Bagi Lulusan Fakultas Hukum',
    image: 'sample-course-image.jpg',
    completionTime: 3,
    totalStudents: 10000,
    rating: 4,
    status: 'passed',
  ),
];

CourseDetail generateDummyCourseDetail(Course course) {
  final scores = [
    Score(
      value: 100,
      status: 'passed',
      dateObtained: DateTime.now(),
    ),
    Score(
      value: 50,
      status: 'failed',
      dateObtained: DateTime.now(),
    ),
  ];

  const item = Item(
    question:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit ut ac interdum orci. Aliquam cursus purus sed ultrices sagittis?',
    answers: {
      'A': 'Choice 1',
      'B': 'Choice 2',
      'C': 'Choice 3',
      'D': 'Choice 4',
    },
    rightAnswerOption: 'A',
  );

  final quizzes = [
    Quiz(
      title: 'Quiz 1: Pengenalan Dokumen Hukum',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ac interdum orci. Praesent auctor sapien non quam tristique, sit amet venenatis ante tincidunt. Aliquam cursus purus sed ultrices sagittis.',
      completionTime: 1,
      items: List<Item>.generate(7, (_) => item),
    ),
    Quiz(
      title: 'Quiz 2: Proses Penerjemahan Dokumen Hukum',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ac interdum orci. Praesent auctor sapien non quam tristique, sit amet venenatis ante tincidunt. Aliquam cursus purus sed ultrices sagittis.',
      completionTime: 1,
      currentScore: scores.first,
      scoreHistory: scores,
      items: List<Item>.generate(7, (_) => item),
    ),
    Quiz(
      title: 'Quiz 2: Proses Penerjemahan Dokumen Hukum',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ac interdum orci. Praesent auctor sapien non quam tristique, sit amet venenatis ante tincidunt. Aliquam cursus purus sed ultrices sagittis.',
      completionTime: 1,
      currentScore: scores.last,
      scoreHistory: scores.reversed.toList(),
      items: List<Item>.generate(7, (_) => item),
    ),
  ];

  const articles = [
    Article(
      title: 'Pelajaran 1: Pengenalan Dokumen Hukum',
      completionTime: 10,
      content: '',
      isComplete: true,
    ),
    Article(
      title: 'Pelajaran 2: Mengapa Perlu Menerjemahkan Dokumen Hukum?',
      completionTime: 10,
      content: '',
      isComplete: true,
    ),
    Article(
      title: 'Pelajaran 3: Proses Penerjemahan Dokumen Hukum',
      completionTime: 10,
      content: '',
    ),
  ];

  final curriculums = [
    Curriculum(
      title: 'Intro: Tips Menerjemahkan Dokumen Hukum Bahasa Asing',
      completionTime: 30,
      lessons: [...articles, quizzes.first, quizzes.last],
      isComplete: true,
    ),
    Curriculum(
      title: 'Prinsip Penerjemahan Dokumen Hukum',
      completionTime: 30,
      lessons: [...articles, quizzes.first, quizzes[1]],
      isComplete: true,
    ),
    Curriculum(
      title: 'Aspek-aspek dalam Menerjemahan Dokumen Hukum',
      completionTime: 30,
      lessons: [...articles, quizzes.first, quizzes.first],
    ),
    Curriculum(
      title: 'Profesi Penerjemah Hukum',
      completionTime: 30,
      lessons: [...articles, quizzes[1], quizzes.last],
    ),
    Curriculum(
      title: 'Studi Kasus & Penutup',
      completionTime: 30,
      lessons: [...articles, quizzes.last, quizzes.last],
    ),
  ];

  final completePercentage = switch (course.status) {
    'active' => 65.0,
    'passed' => 100.0,
    _ => null,
  };

  final certificateUrl = switch (course.status) {
    'passed' => '',
    _ => null,
  };

  return CourseDetail(
    title: course.title,
    image: course.image,
    completionTime: course.completionTime,
    totalStudents: course.totalStudents,
    rating: course.rating,
    status: course.status,
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem.\n\nNam semper vehicula ex, ac fermentum orci elementum ac.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur.',
    curriculums: curriculums,
    completePercentage: completePercentage,
    certificateUrl: certificateUrl,
  );
}
