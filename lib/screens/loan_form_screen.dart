import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/loan.dart';
import '../utils/app_state.dart';
import '../utils/notifier.dart';

class LoanFormScreen extends StatefulWidget {
  final Book book;

  const LoanFormScreen({super.key, required this.book});

  @override
  State<LoanFormScreen> createState() => _LoanFormScreenState();
}

class _LoanFormScreenState extends State<LoanFormScreen> {
  DateTime? _startDate;
  int? _duration;

  bool get _dirty => _startDate != null || _duration != null;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 60)),
    );
    if (!mounted || picked == null) return;
    setState(() => _startDate = picked);
  }

  Future<void> _pickDuration() async {
    final picked = await showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final hari in const [3, 7, 14])
              ListTile(
                leading: const Icon(Icons.timer),
                title: Text('$hari hari'),
                onTap: () => Navigator.pop(sheetContext, hari),
              ),
          ],
        ),
      ),
    );
    if (!mounted || picked == null) return;
    setState(() => _duration = picked);
  }

  Future<void> _ajukan() async {
    final start = _startDate;
    final durasi = _duration;
    if (start == null || durasi == null) {
      showError(context, 'Pilih tanggal mulai dan durasi terlebih dahulu');
      return;
    }

    final due = start.add(Duration(days: durasi));
    final setuju = await showConfirm(
      context,
      'Ringkasan Peminjaman',
      'Judul: ${widget.book.title}\n'
      'Tanggal mulai: ${fmtDate(start)}\n'
      'Jatuh tempo: ${fmtDate(due)}',
      confirmLabel: 'Ajukan',
    );
    if (!mounted || !setuju) return;

    Navigator.pop(
      context,
      Loan(book: widget.book, startDate: start, dueDate: due),
    );
  }

  Future<void> _konfirmasiBuang() async {
    final buang = await showConfirm(
      context,
      'Buang perubahan?',
      'Data yang sudah diisi akan hilang.',
      confirmLabel: 'Buang',
    );
    if (!mounted || !buang) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        await _konfirmasiBuang();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Form Peminjaman')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.book.title,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_today),
                label: Text(_startDate == null
                    ? 'Pilih tanggal mulai'
                    : 'Mulai: ${fmtDate(_startDate!)}'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _pickDuration,
                icon: const Icon(Icons.timer),
                label: Text(_duration == null
                    ? 'Pilih durasi'
                    : 'Durasi: $_duration hari'),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _ajukan,
                  child: const Text('Ajukan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
