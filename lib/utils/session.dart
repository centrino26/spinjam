import 'package:flutter/material.dart';
import 'notifier.dart';

/// Konfirmasi logout, lalu hapus seluruh stack dan kembali ke /login.
Future<void> confirmLogout(BuildContext context) async {
  final setuju = await showConfirm(
    context,
    'Logout',
    'Yakin ingin keluar dari akun?',
    confirmLabel: 'Logout',
  );
  if (!context.mounted || !setuju) return;
  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
}
