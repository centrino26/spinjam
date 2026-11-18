import 'book.dart';

class Loan {
  final Book book;
  final DateTime startDate;
  DateTime dueDate;
  bool extended;

  Loan({
    required this.book,
    required this.startDate,
    required this.dueDate,
    this.extended = false,
  });

  /// Sisa hari sampai jatuh tempo (dihitung per tanggal, tanpa jam).
  int get daysLeft {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return due.difference(today).inDays;
  }
}
