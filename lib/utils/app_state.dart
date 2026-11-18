import 'package:flutter/material.dart';

/// Mode tema aplikasi; bertahan selama aplikasi berjalan.
final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

String fmtDate(DateTime d) {
  final dd = d.day.toString().padLeft(2, '0');
  final mm = d.month.toString().padLeft(2, '0');
  return '$dd/$mm/${d.year}';
}
