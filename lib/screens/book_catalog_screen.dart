import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/library_data.dart';
import '../models/user.dart';
import '../utils/app_state.dart';
import '../utils/session.dart';

class BookCatalogScreen extends StatefulWidget {
  final User user;

  const BookCatalogScreen({super.key, required this.user});

  @override
  State<BookCatalogScreen> createState() => _BookCatalogScreenState();
}

class _BookCatalogScreenState extends State<BookCatalogScreen> {
  String _query = '';
  bool _bannerDismissed = false;

  List<Book> get _filtered => books
      .where((b) =>
          b.title.toLowerCase().contains(_query.toLowerCase()) ||
          b.author.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  int get _dueSoonCount => loans.where((l) => l.daysLeft <= 2).length;

  Future<void> _openDetail(Book book) async {
    await Navigator.pushNamed(context, '/detail', arguments: book);
    // Kembali dari detail: perbarui status buku dan badge.
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _openHistory() async {
    await Navigator.pushNamed(context, '/history');
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    final dueSoon = _dueSoonCount;

    return Scaffold(
      appBar: AppBar(
        title: Text('Halo, ${widget.user.name}'),
        actions: [
          IconButton(
            tooltip: 'Riwayat peminjaman',
            onPressed: _openHistory,
            icon: Badge(
              label: Text('${loans.length}'),
              isLabelVisible: loans.isNotEmpty,
              child: const Icon(Icons.history),
            ),
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () => confirmLogout(context),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                '${widget.user.name}\n${widget.user.nim}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeMode,
              builder: (context, mode, _) => SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                title: const Text('Mode gelap'),
                value: mode == ThemeMode.dark,
                onChanged: (v) =>
                    themeMode.value = v ? ThemeMode.dark : ThemeMode.light,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bug_report),
              title: const Text('Debug: route tidak dikenal'),
              onTap: () => Navigator.pushNamed(context, '/tidak-ada'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => confirmLogout(context),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (dueSoon > 0 && !_bannerDismissed)
            MaterialBanner(
              leading: const Icon(Icons.alarm),
              content: Text('$dueSoon buku jatuh tempo dalam 2 hari atau kurang.'),
              actions: [
                TextButton(
                  onPressed: _openHistory,
                  child: const Text('LIHAT'),
                ),
                TextButton(
                  onPressed: () => setState(() => _bannerDismissed = true),
                  child: const Text('TUTUP'),
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Cari judul atau penulis',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? const Center(child: Text('Buku tidak ditemukan'))
                : ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final book = list[index];
                      return ListTile(
                        leading: Hero(
                          tag: 'cover-${book.id}',
                          child: const Icon(Icons.menu_book, size: 40),
                        ),
                        title: Text(book.title),
                        subtitle: Text('${book.author} • ${book.status}'),
                        trailing: Icon(
                          book.borrowed ? Icons.lock : Icons.check_circle,
                          color: book.borrowed ? Colors.orange : Colors.green,
                        ),
                        onTap: () => _openDetail(book),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
