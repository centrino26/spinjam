import 'book.dart';
import 'loan.dart';

// Data disimpan di memori (tanpa database).
final List<Book> books = [
  Book(id: 1, title: 'Pemrograman Dart', author: 'Andi Wijaya'),
  Book(id: 2, title: 'Flutter untuk Pemula', author: 'Siti Rahma'),
  Book(id: 3, title: 'Struktur Data', author: 'Budi Santoso'),
  Book(id: 4, title: 'Basis Data Relasional', author: 'Dewi Lestari'),
  Book(id: 5, title: 'Jaringan Komputer', author: 'Rudi Hartono'),
  Book(id: 6, title: 'Rekayasa Perangkat Lunak', author: 'Maya Puspita'),
  Book(id: 7, title: 'Algoritma dan Logika', author: 'Eko Prasetyo'),
  Book(id: 8, title: 'Sistem Operasi', author: 'Nina Kartika', borrowed: true),
];

// Daftar peminjaman aktif milik pengguna.
final List<Loan> loans = [];
