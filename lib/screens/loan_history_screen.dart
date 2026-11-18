import 'package:flutter/material.dart';
import '../models/library_data.dart';
import '../models/loan.dart';
import '../utils/app_state.dart';
import '../utils/notifier.dart';

class LoanHistoryScreen extends StatefulWidget {
  const LoanHistoryScreen({super.key});

  @override
  State<LoanHistoryScreen> createState() => _LoanHistoryScreenState();
}

class _LoanHistoryScreenState extends State<LoanHistoryScreen> {
  void _kembalikan(int index) {
    final loan = loans.removeAt(index);
    loan.book.borrowed = false;
    setState(() {});

    showSnack(
      context,
      'Buku ${loan.book.title} dikembalikan',
      actionLabel: 'BATALKAN',
      onAction: () {
        loans.insert(index > loans.length ? loans.length : index, loan);
        loan.book.borrowed = true;
        setState(() {});
      },
    );
  }

  void _perpanjang(BuildContext sheetContext, Loan loan) {
    if (loan.extended) {
      showAlert(
        sheetContext,
        'Tidak dapat diperpanjang',
        'Peminjaman hanya boleh diperpanjang 1 kali.',
      );
      return;
    }
    setState(() {
      loan.dueDate = loan.dueDate.add(const Duration(days: 7));
      loan.extended = true;
    });
    Navigator.pop(sheetContext);
    showSuccess(
      context,
      'Diperpanjang hingga ${fmtDate(loan.dueDate)}',
    );
  }

  void _showDetail(Loan loan) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext sheetContext) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loan.book.title,
                style: Theme.of(sheetContext).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Tanggal pinjam: ${fmtDate(loan.startDate)}'),
            Text('Jatuh tempo: ${fmtDate(loan.dueDate)}'),
            Text('Sudah diperpanjang: ${loan.extended ? 'Ya' : 'Belum'}'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _perpanjang(sheetContext, loan),
                child: const Text('Perpanjang 7 hari'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Peminjaman')),
      body: loans.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inbox_outlined, size: 80),
                  SizedBox(height: 8),
                  Text('Belum ada peminjaman aktif'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: loans.length,
              itemBuilder: (context, index) {
                final loan = loans[index];
                return Dismissible(
                  key: ObjectKey(loan),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.assignment_return,
                        color: Colors.white),
                  ),
                  onDismissed: (_) => _kembalikan(index),
                  child: ListTile(
                    leading: const Icon(Icons.menu_book),
                    title: Text(loan.book.title),
                    subtitle: Text('Jatuh tempo: ${fmtDate(loan.dueDate)}'),
                    onTap: () => _showDetail(loan),
                  ),
                );
              },
            ),
    );
  }
}
