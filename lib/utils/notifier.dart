import 'package:flutter/material.dart';

/// SnackBar dasar; showSuccess dan showError memanggil fungsi ini.
void showSnack(
  BuildContext context,
  String pesan, {
  Color? color,
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 4),
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(pesan),
      backgroundColor: color,
      duration: duration,
      action: (actionLabel != null && onAction != null)
          ? SnackBarAction(label: actionLabel, onPressed: onAction)
          : null,
    ),
  );
}

void showSuccess(BuildContext context, String pesan) {
  showSnack(context, pesan, color: Colors.green.shade700);
}

void showError(BuildContext context, String pesan) {
  showSnack(context, pesan, color: Colors.red.shade700);
}

/// Dialog konfirmasi; mengembalikan true jika pengguna memilih konfirmasi.
Future<bool> showConfirm(
  BuildContext context,
  String judul,
  String pesan, {
  String confirmLabel = 'Ya',
  String cancelLabel = 'Batal',
}) async {
  final hasil = await showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) => AlertDialog(
      title: Text(judul),
      content: Text(pesan),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return hasil ?? false;
}

/// Dialog peringatan satu tombol (mis. akun terkunci, perpanjangan ditolak).
Future<void> showAlert(
  BuildContext context,
  String judul,
  String pesan, {
  bool barrierDismissible = true,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext dialogContext) => AlertDialog(
      title: Text(judul),
      content: Text(pesan),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
