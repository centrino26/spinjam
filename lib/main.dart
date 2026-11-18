import 'package:flutter/material.dart';
import 'models/book.dart';
import 'models/user.dart';
import 'screens/book_catalog_screen.dart';
import 'screens/book_detail_screen.dart';
import 'screens/loan_form_screen.dart';
import 'screens/loan_history_screen.dart';
import 'screens/login_screen.dart';
import 'screens/not_found_screen.dart';
import 'models/loan.dart';
import 'utils/app_state.dart';

void main() {
  runApp(const SiPinjamApp());
}

class SiPinjamApp extends StatelessWidget {
  const SiPinjamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'SiPinjam',
          theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
          darkTheme: ThemeData(
            colorSchemeSeed: Colors.indigo,
            useMaterial3: true,
            brightness: Brightness.dark,
          ),
          themeMode: mode,
          initialRoute: '/login',
          onGenerateRoute: _onGenerateRoute,
        );
      },
    );
  }
}

Route<dynamic> _onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/login':
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const LoginScreen(),
      );
    case '/home':
      final user = settings.arguments as User;
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => BookCatalogScreen(user: user),
      );
    case '/detail':
      final book = settings.arguments as Book;
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => BookDetailScreen(book: book),
      );
    case '/loan-form':
      final book = settings.arguments as Book;
      return MaterialPageRoute<Loan>(
        settings: settings,
        builder: (_) => LoanFormScreen(book: book),
      );
    case '/history':
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const LoanHistoryScreen(),
      );
    default:
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const NotFoundScreen(),
      );
  }
}
