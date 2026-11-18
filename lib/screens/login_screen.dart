import 'dart:async';

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/notifier.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const int _maxAttempts = 3;
  static const int _lockDuration = 30;

  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  int _attempts = 0;
  int _lockSeconds = 0;
  Timer? _timer;

  bool get _locked => _lockSeconds > 0;

  @override
  void dispose() {
    _timer?.cancel();
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _startLock() {
    setState(() => _lockSeconds = _lockDuration);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _lockSeconds--;
        if (_lockSeconds <= 0) timer.cancel();
      });
    });
  }

  Future<void> _login() async {
    final username = _userCtrl.text.trim();
    final password = _passCtrl.text.trim();

    if (username.isEmpty || password.isEmpty) {
      final kosong = [
        if (username.isEmpty) 'Username',
        if (password.isEmpty) 'Password',
      ];
      showError(context, '${kosong.join(' dan ')} tidak boleh kosong');
      return;
    }

    if (username == kValidName && password == kValidNim) {
      // pushReplacementNamed: login diganti dengan /home sehingga
      // tombol back tidak kembali ke halaman login.
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: User(name: username, nim: password),
      );
      return;
    }

    _attempts++;
    if (_attempts >= _maxAttempts) {
      _attempts = 0;
      _startLock();
      await showAlert(
        context,
        'Akun terkunci sementara',
        'Terlalu banyak percobaan gagal. Coba lagi dalam $_lockDuration detik.',
        barrierDismissible: false,
      );
    } else {
      showError(
        context,
        'Username atau password salah. Sisa kesempatan: ${_maxAttempts - _attempts}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SiPinjam')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          children: [
            const Icon(Icons.menu_book, size: 72),
            const SizedBox(height: 24),
            TextField(
              controller: _userCtrl,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _locked ? null : _login,
                child: Text(_locked ? 'Coba lagi dalam $_lockSeconds detik' : 'LOG IN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
