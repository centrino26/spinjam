import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/library_data.dart';
import '../models/loan.dart';
import '../utils/app_state.dart';
import '../utils/notifier.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  Future<void> _pinjam() async {
    // Menerima objek Loan yang dikembalikan form lewat Navigator.pop.
    final loan = await Navigator.pushNamed<Loan>(
      context,
      '/loan-form',
      arguments: widget.book,
    );
    if (!mounted || loan == null) return;

    loans.add(loan);
    widget.book.borrowed = true;
    setState(() {});
    showSuccess(
      context,
      'Buku ${loan.book.title} berhasil dipinjam hingga ${fmtDate(loan.dueDate)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Buku')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: 'cover-${book.id}',
                child: const Icon(Icons.menu_book, size: 120),
              ),
            ),
            const SizedBox(height: 16),
            Text(book.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text('Penulis: ${book.author}'),
            Text('Status: ${book.status}'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: book.borrowed ? null : _pinjam,
                child: const Text('Pinjam'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
