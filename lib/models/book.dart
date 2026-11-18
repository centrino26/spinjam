class Book {
  final int id;
  final String title;
  final String author;
  bool borrowed;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.borrowed = false,
  });

  String get status => borrowed ? 'Dipinjam' : 'Tersedia';
}
