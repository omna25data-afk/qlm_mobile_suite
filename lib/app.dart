import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

class QlmSuiteApp extends StatelessWidget {
  const QlmSuiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement Dynamic Role-based theme switching logic
    return MaterialApp(
      title: 'QLM Mobile Suite',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.guardianTheme, // Default theme
      home: const Scaffold(
        body: Center(
          child: Text('Welcome to QLM Mobile Suite'),
        ),
      ),
    );
  }
}
