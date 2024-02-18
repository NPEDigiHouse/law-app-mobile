//! User
class User {
  final String username;
  final String password;
  final String fullName;
  final String email;
  final String dateOfBirth;
  final String phone;
  final String profilePict;
  final int otp;
  final int roleId;

  const User({
    required this.username,
    required this.password,
    required this.fullName,
    required this.email,
    required this.dateOfBirth,
    required this.phone,
    required this.profilePict,
    required this.otp,
    required this.roleId,
  });
}

const user = User(
  username: 'test',
  password: 'test',
  fullName: 'Kamaruddin Al maliki',
  email: 'test@gmail.com',
  dateOfBirth: '21 Desember 2001',
  phone: '082290380510',
  profilePict: 'no-profile.jpg',
  otp: 1234,
  roleId: 1,
);

const teacher = User(
  username: 'teacher',
  password: 'teacher',
  fullName: 'Dr. Edy Saputra Rusdi',
  email: 'teacher@gmail.com',
  dateOfBirth: '21 Desember 2001',
  phone: '082290380510',
  profilePict: 'no-profile-2.jpg',
  otp: 1234,
  roleId: 2,
);

const admin = User(
  username: 'admin',
  password: 'admin',
  fullName: 'Admin',
  email: 'admin@gmail.com',
  dateOfBirth: '21 Desember 2001',
  phone: '0897182974',
  profilePict: 'no-profile-2.jpg',
  otp: 1234,
  roleId: 0,
);

//! Glossary
class Glossary {
  final String term;
  final String definiton;

  const Glossary({
    required this.term,
    required this.definiton,
  });
}

const dummyGlossaries = [
  Glossary(
    term: 'Abolisi',
    definiton:
        'Penghapusan terhadap seluruh akibat penjatuhan putusan pengadilan pidana kepada seseorang terpidana, terdakwa yang bersalah melakukan delik',
  ),
  Glossary(
    term: 'Deposisi',
    definiton:
        'Bukti saksi atau ahli yang didasarkan atas sumpah yang dilakukan diluar pengadilan',
  ),
  Glossary(
    term: 'De auditu testimonium de auditu',
    definiton:
        'Keterangan saksi yang disampaikan di muka sidang pengadilan yang merupakan hasil pemikiran saja atau hasil rekaan yang diperoleh dari orang lain',
  ),
  Glossary(
    term: 'Pro bono',
    definiton:
        'Suatu perbuatan/pelayanan hokum yang dilakukan untuk kepentingan umum atau pihak yang tidak mampu tanpa dipungut biaya',
  ),
  Glossary(
    term: 'Asas Acta Publica Seseipsa',
    definiton:
        'Suatu akta yang lahirnya tampak sebagai akta otentik serta memenuhi syarat-syarat yang telah ditentukan, sampai terbukti sebaliknya.',
  ),
];

//! Book
class Book {
  final String title;
  final String author;
  final String image;
  final double? completePercentage;

  const Book({
    required this.title,
    required this.author,
    required this.image,
    this.completePercentage,
  });
}

//! BookDetail
class BookDetail extends Book {
  final String category;
  final int totalPage;
  final String publisher;
  final int publishedYear;
  final String synopsis;

  BookDetail({
    required super.title,
    required super.author,
    required super.image,
    super.completePercentage,
    required this.category,
    required this.totalPage,
    required this.publisher,
    required this.publishedYear,
    required this.synopsis,
  });
}

const dummyBooks = [
  Book(
    title: 'Cyber Bullying: Hak-hak Digital Right on Online Safety',
    author: 'Sayid Muhammad Rifqi Noval',
    image: 'sample-book-cover.jpg',
    completePercentage: 62,
  ),
  Book(
    title: 'Hukum Pidana Internasional',
    author: 'Diajeng Wulan Christianti',
    image: 'sample-book-cover.jpg',
    completePercentage: 80,
  ),
  Book(
    title: 'What Would Your Lawyer Say?',
    author: 'Michael Sugijanto',
    image: 'sample-book-cover.jpg',
    completePercentage: 34,
  ),
  Book(
    title: 'Omnibus Law',
    author: 'Rio Christiawan',
    image: 'sample-book-cover.jpg',
  ),
  Book(
    title: 'Filsafat Keadilan: Biological Justice dan Praktiknya',
    author: 'Amran Suadi',
    image: 'sample-book-cover.jpg',
    completePercentage: 100,
  ),
  Book(
    title: 'Teknik Pembuatan Akta Badan Usaha di Era Digital',
    author: 'H. Salim',
    image: 'sample-book-cover.jpg',
  ),
  Book(
    title: 'Matinya Kepakaran',
    author: 'Tom Nichols',
    image: 'sample-book-cover.jpg',
    completePercentage: 100,
  ),
  Book(
    title: 'Hukum Adat Indonesia',
    author: 'Soerjono Soekanto',
    image: 'sample-book-cover.jpg',
  ),
];

//! Question
class Question {
  final User owner;
  final String title;
  final String description;
  final String category;
  final String createdAt;
  final String status;
  final String type;

  const Question({
    required this.owner,
    required this.title,
    required this.description,
    required this.category,
    required this.createdAt,
    required this.status,
    required this.type,
  });

  Question copyWith({
    User? owner,
    String? title,
    String? description,
    String? category,
    String? createdAt,
    String? status,
    String? type,
  }) {
    return Question(
      owner: owner ?? this.owner,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      type: type ?? this.type,
    );
  }
}

const dummyQuestions = [
  Question(
    owner: user,
    title: 'Bolehkah Mengendarai Sepeda Listrik di Jalan Raya?',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac. Mauris ut aliquet justo, et consectetur lorem.',
    category: 'Hukum Perdata',
    createdAt: '24 Desember 2023 (10:23:20)',
    status: 'open',
    type: 'general',
  ),
  Question(
    owner: user,
    title: 'Mengapa Dokumen Hukum yang Ada Harus Diterjemahkan?',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac. Mauris ut aliquet justo, et consectetur lorem.',
    category: 'Hukum Perdata',
    createdAt: '24 Desember 2023 (10:23:20)',
    status: 'discuss',
    type: 'general',
  ),
  Question(
    owner: user,
    title: 'Kapan Putusan Pengadilan Berkekuatan Hukum Tetap?',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac. Mauris ut aliquet justo, et consectetur lorem.',
    category: 'Hukum Perdata',
    createdAt: '24 Desember 2023 (10:23:20)',
    status: 'solved',
    type: 'general',
  ),
  Question(
    owner: user,
    title: 'Konsultasi Hukum oleh Mahasiswa, Memang Boleh?',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac. Mauris ut aliquet justo, et consectetur lorem.',
    category: 'Hukum Perdata',
    createdAt: '24 Desember 2023 (10:23:20)',
    status: 'open',
    type: 'specific',
  ),
  Question(
    owner: user,
    title: 'Arti Due Process of Law',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac. Mauris ut aliquet justo, et consectetur lorem.',
    category: 'Hukum Perdata',
    createdAt: '24 Desember 2023 (10:23:20)',
    status: 'solved',
    type: 'specific',
  ),
  Question(
    owner: User(
      username: 'nanda',
      password: 'nanda',
      fullName: 'Ananda Lesmono',
      email: 'nanda@gmail.com',
      dateOfBirth: '21 Desember 2001',
      phone: '0897182974',
      profilePict: 'no-profile.jpg',
      otp: 1234,
      roleId: 1,
    ),
    title: 'Merangkul Lawan Jenis, Termasuk Pelecehan Seksual?',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac. Mauris ut aliquet justo, et consectetur lorem.',
    category: 'Hukum Perdata',
    createdAt: '24 Desember 2023 (10:23:20)',
    status: 'discuss',
    type: 'specific',
  ),
];

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
  final Map<int, String> answers;
  final int rightAnswerOption;
  final String rightAnswerDescription;

  const Item({
    required this.question,
    required this.answers,
    required this.rightAnswerOption,
    required this.rightAnswerDescription,
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

BookDetail generateDummyBookDetail(Book book) {
  return BookDetail(
    title: book.title,
    author: book.author,
    image: book.image,
    completePercentage: book.completePercentage,
    category: 'Hukum Perdata',
    totalPage: 400,
    publisher: 'Penerbit Erlangga',
    publishedYear: 2018,
    synopsis:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem.\n\nNam semper vehicula ex, ac fermentum orci elementum ac.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur.',
  );
}

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
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit ut ac interdum orci?',
    answers: {
      1: 'Choice 1',
      2: 'Choice 2',
      3: 'Choice 3',
      4: 'Choice 4',
    },
    rightAnswerOption: 3,
    rightAnswerDescription: 'Choice 3',
  );

  final quizzes = [
    Quiz(
      title: 'Quiz 1: Pengenalan Dokumen Hukum',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ac interdum orci. Praesent auctor sapien non quam tristique, sit amet venenatis ante tincidunt. Aliquam cursus purus sed ultrices sagittis.',
      completionTime: 5,
      items: List<Item>.generate(7, (_) => item),
    ),
    Quiz(
      title: 'Quiz 2: Proses Penerjemahan Dokumen Hukum',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ac interdum orci. Praesent auctor sapien non quam tristique, sit amet venenatis ante tincidunt. Aliquam cursus purus sed ultrices sagittis.',
      completionTime: 5,
      currentScore: scores.first,
      scoreHistory: scores,
      items: List<Item>.generate(7, (_) => item),
    ),
    Quiz(
      title: 'Quiz 2: Proses Penerjemahan Dokumen Hukum',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ac interdum orci. Praesent auctor sapien non quam tristique, sit amet venenatis ante tincidunt. Aliquam cursus purus sed ultrices sagittis.',
      completionTime: 5,
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
