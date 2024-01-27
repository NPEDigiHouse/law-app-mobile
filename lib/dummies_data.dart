//! User
class User {
  final String username;
  final String password;
  final String email;
  final int otp;
  final int roleId;

  const User({
    required this.username,
    required this.password,
    required this.email,
    required this.otp,
    required this.roleId,
  });
}

const user = User(
  username: 'test123',
  password: 'test123',
  email: 'test@gmail.com',
  otp: 1234,
  roleId: 1,
);

//! Glossary
class Glossary {
  final String term;
  final String definiton;

  Glossary({
    required this.term,
    required this.definiton,
  });
}

final glossaries = [
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
