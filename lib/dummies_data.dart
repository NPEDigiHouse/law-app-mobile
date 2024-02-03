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
  fullName: 'Kamaruddin Al-maliki',
  email: 'Test@gmail.com',
  dateOfBirth: '21 Mei 2001',
  phone: '0897182974',
  profilePict: 'no-profile.jpg',
  otp: 1234,
  roleId: 1,
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

const glossaries = [
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

const books = [
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

  const Question({
    required this.owner,
    required this.title,
    required this.description,
    required this.category,
    required this.createdAt,
    required this.status,
  });
}

const questions = [
  Question(
    owner: user,
    title: 'Mengapa Dokumen Hukum yang Ada Harus Diterjemahkan?',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac. Mauris ut aliquet justo, et consectetur lorem.',
    category: 'Hukum Perdata',
    createdAt: '24 Desember 2023 (10:23:20)',
    status: 'Open',
  ),
  Question(
    owner: user,
    title: 'Mengapa Dokumen Hukum yang Ada Harus Diterjemahkan?',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac. Mauris ut aliquet justo, et consectetur lorem.',
    category: 'Hukum Perdata',
    createdAt: '24 Desember 2023 (10:23:20)',
    status: 'Discuss',
  ),
  Question(
    owner: user,
    title: 'Mengapa Dokumen Hukum yang Ada Harus Diterjemahkan?',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac. Mauris ut aliquet justo, et consectetur lorem.',
    category: 'Hukum Perdata',
    createdAt: '24 Desember 2023 (10:23:20)',
    status: 'Solved',
  ),
  Question(
    owner: user,
    title: 'Mengapa Dokumen Hukum yang Ada Harus Diterjemahkan?',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac. Mauris ut aliquet justo, et consectetur lorem.',
    category: 'Hukum Perdata',
    createdAt: '24 Desember 2023 (10:23:20)',
    status: 'Open',
  ),
  Question(
    owner: user,
    title: 'Mengapa Dokumen Hukum yang Ada Harus Diterjemahkan?',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi lacinia maximus erat vel fermentum. Mauris ut aliquet justo, et consectetur lorem. Nam semper vehicula ex, ac fermentum orci elementum ac. Mauris ut aliquet justo, et consectetur lorem.',
    category: 'Hukum Perdata',
    createdAt: '24 Desember 2023 (10:23:20)',
    status: 'Solved',
  ),
];
